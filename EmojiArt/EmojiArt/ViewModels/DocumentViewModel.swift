import SwiftUI
import Combine

class DocumentViewModel: ObservableObject {
    static let palette: String = "😀 😃 😄 😁 😆 😅 😂 🤣 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵"
    
    private static let FileTitle = "EmojiDocument.Untitled"
    @Published private var EmojiDocModel: DocumentModel
    @Published private(set) var backgroundImage: UIImage?
    var emojis: [DocumentModel.EmojiType] {EmojiDocModel.emojis}
    
    private var autoSaveCancellable: AnyCancellable?
    init() {
        EmojiDocModel = DocumentModel(json: UserDefaults.standard.data(forKey: DocumentViewModel.FileTitle)) ?? DocumentModel()
        autoSaveCancellable = $EmojiDocModel.sink { EmojiDocModel in
            print("json = \(EmojiDocModel.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(EmojiDocModel.json, forKey: DocumentViewModel.FileTitle)
        }
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
    
    private var fetchImageCancellable: AnyCancellable?
    private func fetchImageData() {
        backgroundImage = nil
        if let url = EmojiDocModel.backgroundURL {
            fetchImageCancellable?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map{data, URLResponse in UIImage(data: data)}
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
            
            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self)
        }
    }
}


extension DocumentModel.EmojiType {
    var fontSize: CGFloat {CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}


