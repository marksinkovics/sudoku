import SwiftUI

class Sudoku: ObservableObject {
    
    let data: BoardData
    let solver: Solver
    
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
