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
    
    var str: String {
        return number == 0 ? "" : "\(number)"
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.number == rhs.number &&
            lhs.selected == rhs.selected &&
            lhs.fixed == rhs.fixed
    }
}

extension Item: CustomStringConvertible,  CustomDebugStringConvertible {
    var description: String {
        return "\(number)"
    }
    
    var debugDescription: String {
        return "\(number)"
    }
}

struct NumpadItem {
    var number: Int = 0
}