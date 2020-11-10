import SwiftUI

struct DocumentsListView: View {
    @EnvironmentObject var store: StoreViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                  NavigationLink(
                    destination: DocumentView(document: document).navigationBarTitle(store.name(for: document)),
                    label: {
                        Text(store.name(for: document))
                    })
                }
            }
            .navigationBarTitle(store.name)
            .navigationBarItems(leading: Button(action: {store.addDocument()}, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }))
        }
    }
}

struct DocumentsListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsListView()
            .environmentObject(StoreViewModel())
    }
}
