import SwiftUI

struct PaletteChooser: View {
    @StateObject var document: DocumentViewModel
    @Binding var ChosenPalette: String
    
    @State private var PopupVisible = false
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: {ChosenPalette = document.palette(after: ChosenPalette)},
                onDecrement: { ChosenPalette = document.palette(before: ChosenPalette)},
                label: {EmptyView()})
            Text(document.paletteNames[ChosenPalette] ?? "")
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {  PopupVisible = true }
                .sheet(isPresented: $PopupVisible, content: {
                    PaletteEditor(ChosenPalette: $ChosenPalette, PopupVisible: $PopupVisible)
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
    @Binding var PopupVisible: Bool
    
    @State private var palleteName: String = ""
    @State private var newEmojis: String = ""
    
    var body: some View  {
        VStack (spacing: 0) {
            ZStack {
                Text("Palette editor")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: {PopupVisible = false}, label: {Text("Done")})
                        .padding()
                }
            }
            
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $palleteName, onEditingChanged: { began in
                        if !began {document.renamePalette(ChosenPalette, to: palleteName)}
                    })
                    
                    TextField("Add emoji", text: $newEmojis, onEditingChanged: { began in
                        if !began {
                            ChosenPalette = document.addEmoji(newEmojis, toPalette: ChosenPalette)
                            newEmojis = ""
                        }
                    })
                }
                
                Section (header: Text("Remove emojis")) {
                    LazyVGrid (columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                        ForEach(ChosenPalette.map { String($0) }, id: \.self) {emoji in
                            Text(emoji)
                                .font(.system(size: EMOJI_SIZE))
                                .padding(.vertical, 6)
                                .onTapGesture { ChosenPalette = document.removeEmoji(emoji, fromPalette: ChosenPalette)}
                            
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {palleteName = document.paletteNames[ChosenPalette] ?? ""}
    }
    
    private let EMOJI_SIZE: CGFloat = 30
}

