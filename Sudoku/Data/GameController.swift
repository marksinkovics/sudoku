import SwiftUI

extension Collection {
    func count(where test:(Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

class GameController: ObservableObject {
    
    let data: BoardData
    let solver: Solver
    let generator: Generator
    var selectedItem: Item?
    var selectedRow: Int?
    var selectedColumn: Int?
    
    var solution: [Int] =  Array(repeating: 81, count: 0)
    
    @Published var finished: Bool
    
    init() {
        data = BoardData()
        solver = Solver(data: self.data)
        generator = Generator(data: data, solver: solver)
        finished = false
    }
    
    func solve() {
        data.grid.enumerated().forEach { index, item in
            if !item.fixed {
                item.number = solution[index]
            }
        }
    }
    
    func clearAll() {
        data.grid.forEach { if !$0.fixed { $0.number = 0 } }
        solution = Array(repeating: 81, count: 0)
    }
    
    func clearSelected() {
        set(number: 0)
    }
    
    func select(row: Int, column: Int) {
        guard selectedRow != row || selectedColumn != column else {
            return
        }

        self.selectedItem?.selected = false
        self.selectedItem = data[row, column]
        self.selectedItem?.selected = true
        self.selectedRow = row
        self.selectedColumn = column

        self.data.unhighlightAll()

        self.data.row(at: row).forEach { $0.highlighted = true }
        self.data.column(at: column).forEach { $0.highlighted = true }
        self.data.neigbourhood(at: row, column).forEach { $0.highlighted = true }
        self.data.grid.filter { $0.number == selectedItem!.number }.forEach {
            if $0.number > 0 {
                $0.highlighted = true;
            }
        }
    }
    
    func set(number: Int) {
        guard let selectedItem = self.selectedItem,
            let selectedRow = self.selectedRow,
            let selectedColumn = self.selectedColumn,
            !selectedItem.fixed else {
            return
        }
        selectedItem.number = number
                
        if validate(number: selectedItem.number, atRow: selectedRow, column: selectedColumn) {
            selectedItem.error = false
            validateBoard();
        } else {
            selectedItem.error = true
        }
    }
    
    func validate(number: Int, atRow row: Int, column: Int) -> Bool {
        guard number != 0 else {
            return true
        }
        
        let index = row * data.rows + column;
        return solution[index] == data[row, column].number
     }
    
    func validateBoard() {
        self.finished = data.grid.count { $0.number == 0 } == 0
    }
    
    func generate() {
        generator.generate(countOfRemovable: 40, solution: &solution)
    }
}
