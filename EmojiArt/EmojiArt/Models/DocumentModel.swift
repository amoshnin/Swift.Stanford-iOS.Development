import Foundation

struct DocumentModel {
    var backgroundURL: URL?
    var emojis = [EmojiType]()
    
    struct EmojiType: Identifiable {
        let text: String
        let id: Int

        var x: Int
        var y: Int
        var size: Int
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y:Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(EmojiType(text: text, id: uniqueEmojiId, x: x, y: y, size: size))
    }
}
