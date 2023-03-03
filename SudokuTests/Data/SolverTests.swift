import XCTest

@testable import Sudoku;

class SolverTests: XCTestCase {
    
    var data: BoardData!
    
    override func setUp() {
        data = BoardData()
        data.reset()
    }
    
    override func tearDown() {
        
    }
    
    func testEmptyBoard() {
        let solver = Solver()
        measure {
            solver.solve(data: data, row: 0, column: 0)
        }
        let expected: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let result = data.row(at: 0).map { $0.number }
        XCTAssertEqual(result, expected)
        debugPrint(data!)
    }
    
    func testPrefilledBoard() {
        let row = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        data.row(at: 0).enumerated().forEach { $1.number = row[$0]; $1.fixed = true }
        let solver = Solver()
        measure {
            solver.solve(data: data, row: 0, column: 0)
        }
        debugPrint(data!)
//        let expected: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
//        let result = data.row(at: 0).map { $0.number }
//        XCTAssertEqual(result, expected)
    }
}
