import Foundation

struct GameModel<CardContent> where CardContent: Equatable {
    // MARK: - Data stored
    // MARK: - private(set) = Read only for external
    private(set) var cards: Array<CardType>
    private var indexOfOneCardFaceUp: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set { for index in cards.indices { cards[index].isFaceUp = index == newValue } }
    }
    
    // MARK: - Model data setter
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<CardType>()
        for index in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(index)
            cards.append(CardType(content: content ))
            cards.append(CardType(content: content ))
        }
    }
    
    // MARK: - Model functions
    mutating func choose(card: CardType) {
        if let chosenIndex: Int = cards.firstIndex(where: {(item) -> Bool in item.id == card.id }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched  {
            if let potentialMatchIndex = indexOfOneCardFaceUp {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
             } else { indexOfOneCardFaceUp = chosenIndex }
        }
    }
    
    // MARK: - Item types
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
