import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        Grid(ViewModel.cards) { card in
            CardView(card: card)
                .padding(5)
                .onTapGesture(perform: { ViewModel.chooseIntent(card: card) })
        }
        
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    var card: GameModel<GameType>.CardType
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
                    RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: STROKE_LINE_WIDTH)
                    Pie(startAngle: .degrees(0-90), endAngle: .degrees(110-90))
                        .padding(9)
                        .opacity(0.4)
                    Text(card.content)
                } else  {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
                    }
                }
            }
            .font(.system(size: fontSize(size: geometry.size) ))
        }
    }
    
    // MARK: - Drawing Constants (Styling)
    private let CORNER_RADIUS: CGFloat = 10
    private let STROKE_LINE_WIDTH: CGFloat = 3
    
    private func fontSize(size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.70
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home(ViewModel: EmojiGameViewModel())
    }
}
