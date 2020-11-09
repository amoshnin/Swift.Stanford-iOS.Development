import SwiftUI

struct Grid<ItemType, ItemView>: View where ItemType: Identifiable, ItemView: View {
    var items: [ItemType]
    var viewForItem: (ItemType) -> ItemView
    
    init(_ items: [ItemType], viewForItem: @escaping (ItemType) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(layout: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    func body(layout: GridLayout) -> some View {
        ForEach(items) { item in
            let index = items.firstIndex(where: {(gridItem) -> Bool in gridItem.id == item.id })
            viewForItem(item)
                .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                .position(layout.location(ofItemAt: index!))
        }
    }
}

