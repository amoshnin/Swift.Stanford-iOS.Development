import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        VStack {
            Grid(ViewModel.cards) { card in
                CardView(card: card)
                    .padding(5)
                    .onTapGesture(perform: { ViewModel.chooseCardReducer(card: card) })
            }
            
            .padding()
            .foregroundColor(.orange)
            
            Button(action: {ViewModel.resetGameReducer()}, label: { Text("Reset game")})
        }
    }
}

struct CardView: View {
    var card: GameModel<GameType>.CardType
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: .degrees(0-90), endAngle: .degrees(110-90))
                        .padding(9)
                        .opacity(0.4)
                    
                    Text(card.content)
                        .font(.system(size: fontSize(size: geometry.size) ))
                        .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.spring().repeatForever(autoreverses: false) : .default)
                }
                .modifier(Cardify(isFaceUp: card.isFaceUp))
            }
        }
    }
    
    // MARK: - Drawing Constants (Styling)
    private func fontSize(size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.70
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home(ViewModel: EmojiGameViewModel())
    }
}
