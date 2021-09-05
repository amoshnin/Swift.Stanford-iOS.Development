import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
