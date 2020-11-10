import SwiftUI

struct Home: View {
    // MARK: - Observing View Model
    @ObservedObject var document: DocumentViewModel
    @State var ChosenPalette: String = ""
    var isLoading: Bool {   document.backgroundURL != nil && document.backgroundImage == nil   }
    
    // MARK: - Zooming in States
    @State private var SteadyZoomScale: CGFloat = 1
    @GestureState private var GestureZoomScale: CGFloat = 1
    private var zoomScale: CGFloat { SteadyZoomScale * GestureZoomScale }
    
    // MARK: - Pan offset States
    @State private var SteadyPanOffset: CGSize = .zero
    @GestureState private var GesturePanOffset: CGSize = .zero
    private var panOffset: CGSize { (SteadyPanOffset + GesturePanOffset) * zoomScale }
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, ChosenPalette: $ChosenPalette)
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ChosenPalette.map {String($0)}, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: EMOJI_SIZE))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear { ChosenPalette = document.defaultPalette }

            }
            
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .overlay(
                            OptionalImage(UIImage: document.backgroundImage)
                                .scaleEffect(zoomScale)
                                .offset(panOffset)
                        )
                        .gesture(DoubleTabGestureToZoom(size: geometry.size))
                    if isLoading {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .spinning()
                        
                    } else {
                        ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(PanGesture())
                .gesture(ZoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(document.$backgroundImage) { image in
                    zoomToFit(image: image, size: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"] , isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return drop(providers: providers, location: location)
                }
            }
        }
    }
    
    private func ZoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($GestureZoomScale, body: { (latestGestureValue, GestureZoomScale, transaction) in
                GestureZoomScale = latestGestureValue
            })
            .onEnded { finalGestureValue in
                SteadyZoomScale *= finalGestureValue
            }
    }
    
    private func PanGesture() -> some Gesture {
        DragGesture()
            .updating($GesturePanOffset) { (latestGestureValue, GesturePanOffset, transaction) in
                GesturePanOffset = latestGestureValue.translation / zoomScale
            }
            .onEnded { finalGestureValue in
                SteadyPanOffset = SteadyPanOffset + (finalGestureValue.translation / zoomScale)
            }
    }
    
    private func DoubleTabGestureToZoom(size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation(.spring()) {zoomToFit(image: document.backgroundImage, size: size)}
            }
    }
    
    private func zoomToFit(image: UIImage?, size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let HZoom = size.width / image.size.width
            let VZoom = size.height / image.size.height
            SteadyPanOffset = .zero
            SteadyZoomScale = min(HZoom, VZoom)
        }
    }
    
    private func position(for emoji: DocumentModel.EmojiType, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x:  location.x + size.width / 2, y:  location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in document.backgroundURL  = url }
        if !found {
            found = providers.loadObjects(ofType: String.self, using: { (string) in  document.addEmoji(string, at: location, size: EMOJI_SIZE) })
        }
        return found
    }
    private let EMOJI_SIZE: CGFloat = 40
}


struct OptionalImage: View {
    var UIImage: UIImage?
    
    var body: some View {
        Group {
            if let backgroundImage = UIImage {
                Image(uiImage: backgroundImage)}
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(document: DocumentViewModel())
    }
}
