import SwiftUI

class NumpadItem: ObservableObject {
    
    var number: Int
    @Published var hidden: Bool = false
    var text: String {
        return "\(number)"
    }
    
    init(number: Int) {
        self.number = number
    }
}
