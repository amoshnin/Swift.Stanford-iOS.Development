import Foundation

struct DocumentModel: Codable {
    var backgroundURL: URL?
    var emojis = [EmojiType]()
    
    struct EmojiType: Identifiable, Codable, Hashable {
        let text: String
        let id: Int

        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(text: String, id: Int, x: Int, y: Int, size: Int) {
            self.text = text
            self.id = id
            
            self.x = x
            self.y = y
            self.size = size
        }
    }
    
    var json: Data? { return try? JSONEncoder().encode(self) }
    
    init?(json: Data?) {
        if json != nil, let newDocument = try? JSONDecoder().decode(DocumentModel.self, from: json!) {
            self = newDocument
        } else { return nil }
    }
    
    init() {}
     
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y:Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(EmojiType(text: text, id: uniqueEmojiId, x: x, y: y, size: size))
    }
}
