import SwiftUI

struct Home: View {
    // MARK: - Observing the model store
    @ObservedObject var ViewModel: EmojiGameViewModel
    
    var body: some View {
        HStack {
            ForEach(ViewModel.cards) { item in
                CardView(card: item)
                    .onTapGesture(perform: { ViewModel.chooseIntent(card: item) })
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(.largeTitle)
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
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10).fill(Color.white)
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                Text(card.content)
            } else  {
                RoundedRectangle(cornerRadius: 10).fill()
            }
        }
    }
}
