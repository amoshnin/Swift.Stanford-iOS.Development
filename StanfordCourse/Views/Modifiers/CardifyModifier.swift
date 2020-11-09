import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if  isFaceUp {
                RoundedRectangle(cornerRadius: CORNER_RADIUS).fill(Color.white)
                RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke(lineWidth: STROKE_LINE_WIDTH)
                content
            } else {
                RoundedRectangle(cornerRadius: CORNER_RADIUS).fill()
            }
        }
    }
    
    // MARK: - Drawing Constants (Styling)
    private let CORNER_RADIUS: CGFloat = 10
    private let STROKE_LINE_WIDTH: CGFloat = 3
}
