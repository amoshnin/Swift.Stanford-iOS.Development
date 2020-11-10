import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: DocumentViewModel
    @Binding var ChosenPalette: String
    
    @State private var editPopupVisible = false
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: {ChosenPalette = document.palette(after: ChosenPalette)},
                onDecrement: { ChosenPalette = document.palette(before: ChosenPalette)},
                label: {EmptyView()})
            Text(document.paletteNames[ChosenPalette] ?? "")
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {  editPopupVisible = true }
                .popover(isPresented: $editPopupVisible, content: {
                    PaletteEditor(ChosenPalette: $ChosenPalette)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 500 )
                })
        }
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: DocumentViewModel
    @Binding var ChosenPalette: String
    
    @State private var palleteName: String = ""
    
    
    
    
    
    var body: some View  {
        VStack (spacing: 0) {
            Text("Palette editor")
                .font(.headline)
                .padding()
            
            Divider()
            TextField("Palette Name", text: $palleteName)
                .padding()
            
            Spacer()
        }
        .onAppear {palleteName = document.paletteNames[ChosenPalette] ?? ""}
    }
}

