import SwiftUI

struct DocumentsListView: View {
    @EnvironmentObject var store: StoreViewModel
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                  NavigationLink(
                    destination: DocumentView(document: document).navigationBarTitle(store.name(for: document)),
                    label: {EditableText(store.name(for: document), isEditing: editMode.isEditing) { (text) in store.setName(text, for: document)}})
                }
                .onDelete { indexSet in
                    indexSet.map { store.documents[$0] }.forEach { document in
                        store.removeDocument(document)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(store.name)
            .navigationBarItems(leading: Button(action: {store.addDocument()}, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }), trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    }
}

struct DocumentsListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsListView()
            .environmentObject(StoreViewModel())
    }
}
