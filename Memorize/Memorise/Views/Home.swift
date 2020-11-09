import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        
        VStack {
            Grid(ViewModel.cards) { card in
                CardView(card: card)
                    .padding(5)
                    .onTapGesture(perform: { withAnimation(.spring()) { ViewModel.chooseCardReducer(card: card) }})
            }
            .padding()
            .foregroundColor(.orange)
            
            Button(action: {withAnimation(.easeInOut(duration:2)){ViewModel.resetGameReducer()}}, label: { Text("Reset game")})
        }
    }
}

struct CardView: View {
    @State private var bonusRemaining: Double = 0
    var card: GameModel<GameType>.CardType
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(
                                startAngle: .degrees(0-90),
                                endAngle: .degrees(-bonusRemaining*360-90))
                                .onAppear {
                                    bonusRemaining = card.bonusRemaining
                                    withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                        bonusRemaining = 0
                                    }
                                }
                        } else {
                            Pie(
                                startAngle: .degrees(0-90),
                                endAngle:   .degrees(-card.bonusRemaining*360-90))
                        }
                    }
                    .padding(9)
                    .opacity(PIE_OPACITY)
                    .transition(.scale)
                    
                    Text(card.content)
                        .font(.system(size: fontSize(size: geometry.size) ))
                        .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.spring().repeatForever(autoreverses: false) : .default)
                }
                .modifier(Cardify(isFaceUp: card.isFaceUp))
                .transition(.scale)
            }
        }
    }
    
    // MARK: - Drawing Constants (Styling)
    private let PIE_OPACITY: Double  = 0.4
    private func fontSize(size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.70
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home(ViewModel: EmojiGameViewModel())
    }
}
