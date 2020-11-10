import SwiftUI

class DocumentViewModel: ObservableObject {
    static let palette: String = "😀 😃 😄 😁 😆 😅 😂 🤣 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵"
    
    private static let FileTitle = "EmojiDocument.Untitled"
    @Published private var EmojiDocModel: DocumentModel = DocumentModel() {
        didSet {
            print("json = \(EmojiDocModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(EmojiDocModel.json, forKey: DocumentViewModel.FileTitle)
        }
    }
    @Published private(set) var backgroundImage: UIImage?
    var emojis: [DocumentModel.EmojiType] {EmojiDocModel.emojis}
    
    init() {
        EmojiDocModel = DocumentModel(json: UserDefaults.standard.data(forKey: DocumentViewModel.FileTitle)) ?? DocumentModel()
        fetchImageData()
    }
    
    
    // MARK: - Intent(s)
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        EmojiDocModel.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: DocumentModel.EmojiType, by offset: CGSize) {
        if let index = EmojiDocModel.emojis.firstIndex(where: { (item) -> Bool in item.id == emoji.id }) {
            EmojiDocModel.emojis[index].x += Int(offset.width)
            EmojiDocModel.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: DocumentModel.EmojiType, by scale: CGFloat) {
        if let index = EmojiDocModel.emojis.firstIndex(where: { (item) -> Bool in item.id == emoji.id }) {
            EmojiDocModel.emojis[index].size = Int((CGFloat(EmojiDocModel.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get { EmojiDocModel.backgroundURL }
        set {
            EmojiDocModel.backgroundURL = newValue?.imageURL
            fetchImageData()
        }
    }
    
    private func fetchImageData() {
        backgroundImage = nil
        if let url = EmojiDocModel.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.EmojiDocModel.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
            
        }
    }
}


extension DocumentModel.EmojiType {
    var fontSize: CGFloat {CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}


