import Foundation

class Generator {

    var solver: Solver = Solver()

    func generate(data: BoardData, difficulty: BoardData.Difficulty) {
        data.reset()
        data.difficulty = difficulty
        let row = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
        data.row(at: 0).enumerated().forEach { $1.number = row[$0]; }
        self.solver.solve(data: data, row: 1, column: 0)
        data.solution = data.grid.map { $0.number }
        let removableElements = data.grid.shuffled().prefix(difficulty.countOfRemovable);
        removableElements.forEach { $0.number = 0 }
        data.grid.forEach { if $0.number != 0 { $0.fixed = true }}
    }
}
