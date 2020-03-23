import SwiftUI

class Sudoku: ObservableObject {
    
    let data: BoardData
    let solver: Solver
    var selectedItem: Item?
    var selectedRow: Int?
    var selectedColumn: Int?
    
    init() {
        data = BoardData()
        solver = Solver(data: self.data)
    }
    
    func solve() {
        solver.solve(atRow: 0, column: 0)
    }
    
    func clear() {
        data.grid.forEach { if !$0.fixed { $0.number = 0 } }
    }
    
    func select(item: Item, atRow row: Int, column: Int) {
        guard selectedRow != row || selectedColumn != column else {
            return
        }

        self.selectedItem?.selected = false
        self.selectedItem = item
        self.selectedItem?.selected = true
        self.selectedRow = row
        self.selectedColumn = column

        self.data.unhighlightAll()

        self.data.row(at: self.selectedRow!).forEach { $0.highlighted = true }
        self.data.column(at: column).forEach { $0.highlighted = true }
        self.data.neigbourhood(at: row, column).forEach { $0.highlighted = true }
    }
    
    func set(number: Int) {
        guard let selectedItem = self.selectedItem, !selectedItem.fixed else {
            return
        }
        selectedItem.number = number
    }
    
    func generate() {
        data.reset()
        let row = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
        data.row(at: 0).enumerated().forEach { $1.number = row[$0]; }
        self.solver.solve(atRow: 1, column: 0)
        
        let countOfRemovable = 40;
        
        let removableElements = data.grid.shuffled().prefix(countOfRemovable);
        removableElements.forEach { $0.number = 0 }
        data.grid.forEach { if $0.number != 0 { $0.fixed = true }}
    }
}
