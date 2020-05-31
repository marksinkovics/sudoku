import Foundation

class Generator {
    
    var data: BoardData
    var solver: Solver
        
    init(data: BoardData, solver: Solver) {
        self.data = data
        self.solver = solver
    }
    
    func generate(difficulty: BoardData.Difficulty, countOfRemovable: Int = 40) {
        data.reset()
        data.difficulty = difficulty
        
        let row = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
        
        data.row(at: 0).enumerated().forEach { $1.number = row[$0]; }
        self.solver.solve(atRow: 1, column: 0)

        data.solution = data.grid.map { $0.number }
    
        let removableElements = data.grid.shuffled().prefix(countOfRemovable);
        removableElements.forEach { $0.number = 0 }
        data.grid.forEach { if $0.number != 0 { $0.fixed = true }}
    }
    
}
