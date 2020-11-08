import SwiftUI

typealias GameType = String
class EmojiGameViewModel: ObservableObject {
    @Published private var model: GameModel<GameType> = EmojiGameViewModel.createGame()
    
    static func createGame() -> GameModel<GameType> {
        let emojis: Array<GameType> = ["🥶", "😳", "😳" , "🥶"]
        return GameModel<GameType>(numberOfPairsOfCards: emojis.count, cardContentFactory: {index in emojis[index]})
    }
    
    // MARK: - Access to the Model
    var cards: Array<GameModel<GameType>.CardType> { model.cards }
    
    // MARK: - Intent(s)
    func chooseIntent(card: GameModel<GameType>.CardType) {
        model.choose(card: card)
    }
}


