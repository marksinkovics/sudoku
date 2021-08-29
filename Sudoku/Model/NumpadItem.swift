import SwiftUI

class NumpadItem: ObservableObject {
    
    enum ItemValue: CustomStringConvertible, Equatable {
        case number(Int)
        
        var description: String {
            switch self {
                case .number(let number): return "\(number)"
            }
        }
        
        var systemImage: String? {
            switch self {
                default:
                    return nil
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (let .number(number1), let .number(number2)):
                return number1 == number2
            }
        }
    }
    
    var value: ItemValue
    
    @Published var hidden: Bool = false
    @Published var selected: Bool = false
    
    var text: String {
        self.value.description
    }
    
    init(value: ItemValue, hidden: Bool = false, selected: Bool = false) {
        self.value = value
        self.hidden = hidden
        self.selected = selected
    }
}
