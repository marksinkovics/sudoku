import XCTest

@testable import Sudoku;

class BoardDataTests: XCTestCase {

    private var boardData: BoardData!
    private var solvedBoardData: BoardData!
    
    override func setUp() {
        boardData = BoardData([
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            4, 5, 6, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 1, 0, 0, 0, 0, 0,
            0, 0, 0, 2, 0, 0, 0, 0, 0,
            0, 0, 0, 3, 0, 0, 0, 0, 0,
            0, 0, 0, 5, 0, 0, 0, 0, 0,
            0, 0, 0, 6, 0, 0, 0, 0, 0,
            0, 0, 0, 7, 0, 0, 0, 0, 0,
            0, 0, 0, 8, 0, 0, 0, 0, 0,
        ])
        
        solvedBoardData = BoardData([
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            7, 8, 9, 1, 2, 3, 4, 5, 6,
            4, 5, 6, 7, 8, 9, 1, 2, 3,
            3, 1, 2, 8, 4, 5, 9, 6, 7,
            6, 9, 7, 3, 1, 2, 8, 4, 5,
            8, 4, 5, 6, 9, 7, 3, 1, 2,
            2, 3, 1, 5, 7, 4, 6, 9, 8,
            9, 6, 8, 2, 3, 1, 5, 7, 4,
            5, 7, 4, 9, 6, 8, 2, 3, 1
        ]);
    }
    
    func testGetter() {
        XCTAssertEqual(boardData[0, 0].number, 1)
    }
        
    func testGettingSelectedItem() {
        boardData.deselectAll()
        boardData[0, 0].selected = true
        XCTAssertEqual(boardData.selectedItem(), boardData[0, 0])
    }

    func testDeselection() {
        boardData[0, 0].selected = true
        boardData.deselectAll()
        XCTAssertNil(boardData.selectedItem())
    }
    
    func testNumberAssignment() {
        XCTAssertEqual(boardData[0, 0].number, 1)
        XCTAssertEqual(boardData[0, 1].number, 2)
        XCTAssertEqual(boardData[1, 0].number, 4)
        XCTAssertEqual(boardData[1, 1].number, 5)
    }
    
    func testRowGetter() {
        let row_0 = boardData.row(at: 0)
        XCTAssertEqual(row_0[0].number, 1)
        XCTAssertEqual(row_0[1].number, 2)

        let row_1 = boardData.row(at: 1)
        XCTAssertEqual(row_1[0].number, 4)
        XCTAssertEqual(row_1[1].number, 5)
    }
    
    func testColumnGetter() {
        let column_0 = boardData.column(at: 0)
        XCTAssertEqual(column_0[0].number, 1)
        XCTAssertEqual(column_0[1].number, 4)

        let column_1 = boardData.column(at: 1)
        XCTAssertEqual(column_1[0].number, 2)
        XCTAssertEqual(column_1[1].number, 5)
    }
    
    func testNeighbourhoodGetter() {
        let neighourhood = solvedBoardData.neigbourhood(at: 7, 8).map { $0.number }
        XCTAssertEqual(neighourhood, [6, 9, 8, 5, 7, 4, 2, 3, 1])
    }
    
    func testNumberValidation() {
        XCTAssertTrue(boardData.isValid(number: 9, at: 5, column: 2))
        XCTAssertFalse(boardData.isValid(number: 6, at: 5, column: 2))
    }
    
    func testPossibleNumbers() {
        let numbers = boardData.possibleNumbers(at: 1, column: 4)
        XCTAssertEqual(numbers, [2, 3, 7, 8, 9])
        
        let number = boardData.possibleNumbers(at: 1, column: 3)
        XCTAssertEqual(number, [9])
    }
}
