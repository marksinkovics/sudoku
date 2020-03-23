import SwiftUI

class BoardData: ObservableObject  {
        
    let rows: Int = 9
    let columns: Int = 9
    var grid: [Item] = (1...81).map { _ in Item() }
    
    init() {}
    
    convenience init(_ numbers: [Int]) {
        precondition(numbers.count == 81, "The count of the input numbers must be 81")
        self.init()
        self.grid = numbers.map { Item(number: $0) }
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
    
    func neigbourhood(at row: Int, _ column: Int) -> [Item] {
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
        let row_numbers = self.row(at: row).map { $0.number }
        let column_numbers = self.column(at: column).map { $0.number }
        let neighbours = self.neigbourhood(at: row, column).map { $0.number }
        let isContained = row_numbers.contains(number)
            || column_numbers.contains(number)
            || neighbours.contains(number)
        
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
