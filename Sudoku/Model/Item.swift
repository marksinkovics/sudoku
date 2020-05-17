import SwiftUI

class DraftItem: ObservableObject, Codable {
    
    @Published var number: Int = 0
    @Published var hidden: Bool = true
    
    convenience init(number: Int = 0, hidden: Bool = true) {
        self.init()
        self.number = number
        self.hidden = hidden
    }
    
    var text: String {
        "\(number)"
    }
    
    func hiddenToggle() {
        hidden = !hidden
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case hidden
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(Int.self, forKey: .number)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(hidden, forKey: .hidden)
    }

}

class Item: ObservableObject, Codable {
    
    @Published var number: Int = 0 {
        didSet {
            if number != 0 {
                self.draftNumbers.forEach { $0.hidden = true }
            }
        }
    }
    @Published var selected: Bool = false
    @Published var highlighted: Bool = false
    @Published var fixed: Bool = false
    @Published var error: Bool = false
    @Published var draftNumbers: [DraftItem] = (1...9).map { DraftItem(number: $0) }
    
    convenience init(number: Int = 0, draftNumbers: [DraftItem]? = nil) {
        self.init()
        self.number = number
        
        if let draftNumbers = draftNumbers, draftNumbers.count == 9 {
            self.draftNumbers = draftNumbers
        }
    }
    
    var str: String {
        return number == 0 ? "" : "\(number)"
    }
    
    enum CodingKeys: String, CodingKey {
        case number
        case selected
        case fixed
        case error
        case drafts
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(Int.self, forKey: .number)
        self.selected = try container.decode(Bool.self, forKey: .selected)
        self.fixed = try container.decode(Bool.self, forKey: .fixed)
        self.error = try container.decode(Bool.self, forKey: .error)
        self.draftNumbers = try container.decode([DraftItem].self, forKey: .drafts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(selected, forKey: .selected)
        try container.encode(fixed, forKey: .fixed)
        try container.encode(error, forKey: .error)
        try container.encode(draftNumbers, forKey: .drafts)
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
