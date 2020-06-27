import SwiftUI


class BoardData: ObservableObject, Codable  {
    
    enum Difficulty: Int, Codable, CustomStringConvertible, Equatable {
        case undefined
        case easy
        case medium
        case hard
        case expert
        
        var description: String {
            switch self {
                case .easy: return "Easy"
                case .medium: return "Medium"
                case .hard: return "Hard"
                case .expert: return "Expert"
                default: return ""
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case (.easy, .easy):
                    return true
                case (.medium, .medium):
                    return true
                case (.hard, .hard):
                    return true
                case (.expert, .expert):
                    return true
                default:
                    return false
            }
        }
        
        var countOfRemovable: Int {
            switch self {
                case .undefined: return 0
                case .easy: return 28
                case .medium: return 37
                case .hard: return 45
                case .expert: return 65
            }
        }
    }

    let rows: Int = 9
    let columns: Int = 9
    var grid: [Item] = (1...81).map { _ in Item() }
    var solution: [Int] =  Array(repeating: 81, count: 0)
    var difficulty: Difficulty = .undefined

    convenience init(_ numbers: [Int]) {
        precondition(numbers.count == 81, "The count of the input numbers must be 81")
        self.init()
        self.grid = numbers.map { Item(number: $0) }
    }
    
    enum CodingKeys: String, CodingKey {
        case grid
        case solution
        case difficulty
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.grid = try container.decode([Item].self, forKey: .grid)
        self.solution = try container.decode([Int].self, forKey: .solution)
        self.difficulty  = try container.decode(Difficulty.self, forKey: .difficulty)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(grid, forKey: .grid)
        try container.encode(solution, forKey: .solution)
        try container.encode(difficulty, forKey: .difficulty)
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return rowIsValid(row: row) && columnIsValid(column: column)
    }
    
    func rowIsValid(row: Int) -> Bool {
        return row >= 0 && row < rows
    }
    
    func columnIsValid(column: Int) -> Bool {
        return column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Item {
        get {
            precondition(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            precondition(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    func row(at row: Int) -> [Item] {
        precondition(rowIsValid(row: row), "Index out of range")
        let startPosition = columns * row
        let endPosition = startPosition + columns
        return Array(grid[startPosition..<endPosition]);
    }
    
    func column(at column: Int) -> [Item] {
        precondition(columnIsValid(column: column), "Index out of range")
        let indices = Array(0..<rows).map { $0 * columns + column }
        return indices.map { grid[$0] }
    }
    
    func selectedItem() -> Item? {
        return grid.filter { $0.selected }.first
    }
    
    func selectedRow() -> Int? {
        guard let selectedItem = selectedItem(), let index = grid.firstIndex(of: selectedItem) else {
            return nil
        }
        return index / columns;
    }
    
    func selectedColumn() -> Int? {
        guard let selectedItem = selectedItem(), let index = grid.firstIndex(of: selectedItem) else {
            return nil
        }
        return index % columns;
    }
    
    func deselectAll() {
        return grid.forEach { $0.selected = false }
    }
    
    func unhighlightAll() {
        return grid.forEach { $0.highlighted = false }
    }
    
    func assignNumber(action: (Int, Int) -> Int) {
        for index in 0..<grid.count {
            let row = index / columns
            let column = index % columns
            grid[index].number = action(row, column)
        }
    }
    
    func forEach(action: (Item, Int, Int) -> Void) {
        for index in 0..<grid.count {
            let row = index / columns
            let column = index % columns
            action(grid[index], row, column)
        }
    }
    
    func reset() {
        grid.forEach { $0.number = 0; $0.fixed = false }
    }
    
    func block(at row: Int, _ column: Int) -> [Item] {
        precondition(indexIsValid(row: row, column: column), "Index out of range")
        let i = (row / 3) * 3
        let j = (column / 3) * 3
        
        return [
            self[i    , j], self[i    , j + 1], self[i    , j + 2],
            self[i + 1, j], self[i + 1, j + 1], self[i + 1, j + 2],
            self[i + 2, j], self[i + 2, j + 1], self[i + 2, j + 2]
        ]
    }
    
    func isValid(number: Int, at row: Int, column: Int) -> Bool {
        let rowNumbers = self.row(at: row).map { $0.number }
        let columnNumbers = self.column(at: column).map { $0.number }
        let blockNumber = self.block(at: row, column).map { $0.number }
        let isContained = rowNumbers.contains(number)
            || columnNumbers.contains(number)
            || blockNumber.contains(number)
        
        return !isContained
    }
    
    func possibleNumbers(at row: Int, column: Int) -> [Int] {
        return (1...9).filter { isValid(number: $0, at: row, column: column) }
    }
}

extension BoardData: CustomStringConvertible {
    
    var description: String {
        (0..<self.rows).map { self.row(at: $0).map { "\($0)" }.joined(separator: " ") }.joined(separator: "\n")
    }
}
