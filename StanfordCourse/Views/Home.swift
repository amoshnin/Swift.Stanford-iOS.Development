import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            LazyVGrid (columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16 ) {
                ForEach(ViewModel.cards) { item in
                    CardView(card: item)
                        .frame(height: 200)
                        .onTapGesture(perform: { ViewModel.chooseIntent(card: item) })
                }
            }
            .padding(.horizontal, 24)
            
        }
        .foregroundColor(.orange)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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

