import SwiftUI

@main
struct Index: App {
    var body: some Scene {
        WindowGroup {
            Home(document: DocumentViewModel())
        }
    }
}
