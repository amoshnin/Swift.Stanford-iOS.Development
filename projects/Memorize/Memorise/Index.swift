import SwiftUI

@main
struct Index: App {
    var body: some Scene {
        WindowGroup {
            let game = EmojiGameViewModel()
            Home(ViewModel: game)
        }
    }
}
