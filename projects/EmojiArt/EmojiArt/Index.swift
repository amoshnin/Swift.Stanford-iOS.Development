import SwiftUI

@main
struct Index: App {
    
    var body: some Scene {
        WindowGroup {
            DocumentsListView()
                .environmentObject(StoreViewModel())
        }
    }
}
