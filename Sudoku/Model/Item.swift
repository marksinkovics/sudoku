import SwiftUI

class Item: ObservableObject, Codable {
    
    @Published var number: Int = 0
    @Published var selected: Bool = false
    @Published var highlighted: Bool = false
    @Published var fixed: Bool = false
    @Published var error: Bool = false
    
    convenience init(number: Int) {
        self.init()
        self.number = number
    }
    
    var str: String {
        return number == 0 ? "" : "\(number)"
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case selected
        case fixed
        case error
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(Int.self, forKey: .number)
        self.selected = try container.decode(Bool.self, forKey: .selected)
        self.fixed = try container.decode(Bool.self, forKey: .fixed)
        self.error = try container.decode(Bool.self, forKey: .error)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(selected, forKey: .selected)
        try container.encode(fixed, forKey: .fixed)
        try container.encode(error, forKey: .error)
    }

}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.number == rhs.number &&
            lhs.selected == rhs.selected &&
            lhs.highlighted == rhs.highlighted &&
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
