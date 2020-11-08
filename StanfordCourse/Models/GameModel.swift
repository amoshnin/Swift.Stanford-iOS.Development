import Foundation

struct GameModel<CardContent> {
    var cards: Array<CardType>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<CardType>()
        for index in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(index)
            cards.append(CardType(content: content ))
            cards.append(CardType(content: content ))
        }
    }
    
    mutating func choose(card: CardType) {
        let chosenIndex: Int = cards.firstIndex(where: {(item) -> Bool in item.id == card.id })!
        cards[chosenIndex].isFaceUp = !cards[chosenIndex].isFaceUp
    }
    
    struct CardType: Identifiable, Equatable {
        static func == (lhs: GameModel<CardContent>.CardType, rhs: GameModel<CardContent>.CardType) -> Bool {
            lhs.isFaceUp == rhs.isFaceUp && lhs.isMatched == rhs.isMatched
        }
        
        var id = UUID()
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
     }
}
