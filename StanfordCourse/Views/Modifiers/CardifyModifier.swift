import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var isFaceUp: Bool {  rotation < 90  }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
                RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: STROKE_LINE_WIDTH)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            
            RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
                .opacity(isFaceUp ? 0 : 1)
            
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0) )
    }
    
    // MARK: - Drawing Constants (Styling)
    private let CORNER_RADIUS: CGFloat = 10
    private let STROKE_LINE_WIDTH: CGFloat = 3
}
