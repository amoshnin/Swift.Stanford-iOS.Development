import SwiftUI

struct Home: View {
    @ObservedObject var document: DocumentViewModel
    
    var body: some View {
        VStack {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(DocumentViewModel.palette.map {String($0)}, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: EMOJI_SIZE))
                    }
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .foregroundColor(.yellow)
                .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
    
    private let EMOJI_SIZE: CGFloat = 40
}
 
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(document: DocumentViewModel())
    }
}
