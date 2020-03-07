import SwiftUI

class Item: ObservableObject {
    
    @Published var number: Int
    @Published var selected: Bool
    @Published var fixed: Bool
    
    convenience init() {
        self.init(number: 0, selected: false, fixed: false)
    }
    
    init(number: Int = 0, selected: Bool = false, fixed: Bool = false) {
        self.number = number
        self.selected = selected
        self.fixed = fixed
    }
    
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.number == rhs.number &&
            lhs.selected == rhs.selected &&
            lhs.fixed == rhs.fixed
    }
}

struct NumpadItem {
    var number: Int = 0
}
