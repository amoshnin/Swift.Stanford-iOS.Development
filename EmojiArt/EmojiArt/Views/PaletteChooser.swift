import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: DocumentViewModel
    @Binding var ChosenPalette: String
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                ChosenPalette = document.palette(after: ChosenPalette)
            }, onDecrement: {
                ChosenPalette = document.palette(before: ChosenPalette)
            }, label: {EmptyView()})
            Text(document.paletteNames[ChosenPalette] ?? "")
        }
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        .onAppear { ChosenPalette = document.defaultPalette }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: DocumentViewModel(), ChosenPalette: .constant(""))
    }
}
