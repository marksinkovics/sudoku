import SwiftUI

class BoardData: ObservableObject  {
    
    let rows: Int
    let columns: Int
    var grid: [Item]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = []
        
        for _ in 1...(rows * columns) {
            grid.append(Item())
        }
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
    
    func assignNumber(action: (Int, Int) -> Int) {
        for index in 0..<grid.count {
            let row = index / columns
            let column = index % columns
            self[row, column].number = action(row, column)
        }
    }
}
