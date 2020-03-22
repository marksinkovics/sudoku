import Foundation

class Generator {
    
    enum Difficulty {
        case easy, medium, hard, expert
    }
    
    var data: BoardData
    var solver: Solver
        
    init(data: BoardData, solver: Solver? = nil) {
        self.data = data
        self.solver = solver ?? Solver(data: data)
    }
    
    func generate() {
    }
    
}
