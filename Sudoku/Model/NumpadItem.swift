import SwiftUI

class NumpadItem: ObservableObject {
    
    enum ItemValue: CustomStringConvertible, Equatable {
        case number(Int)
        case delete
        case reset
        case solve
        case normal
        case draft
        
        var description: String {
            switch self {
                case .number(let number): return "\(number)"
                case .delete: return "Del"
                case .reset: return "Reset"
                case .solve: return "Solve"
                case .normal: return "Normal"
                case .draft: return "Draft"
            }
        }
        
        var systemImage: String? {
            switch self {
                case .delete: return "trash"
                default:
                    return nil
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (let .number(number1), let .number(number2)):
                return number1 == number2
            case (.delete, .delete):
                return true
            case (.reset, .reset):
                return true
            case (.solve, .solve):
                return true
            case (.normal, .normal):
                return true
            case (.draft, .draft):
                return true
            default:
                return false
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
