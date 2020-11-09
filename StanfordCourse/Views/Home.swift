import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        Grid(ViewModel.cards) { item in
            CardView(card: item)
                .padding(5)
                .onTapGesture(perform: { ViewModel.chooseIntent(card: item) })
        }
        
        .padding()
        .foregroundColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home(ViewModel: EmojiGameViewModel())
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
                    Text(card.content)
                } else  {
                    RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
                }
            }
            .font(.system(size: fontSize(size: geometry.size) ))
        }
    }
    
    // MARK: - Drawing Constants (Styling)
    let CORNER_RADIUS: CGFloat = 10
    let STROKE_LINE_WIDTH: CGFloat = 3
    
    func fontSize(size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.70
    }
}

