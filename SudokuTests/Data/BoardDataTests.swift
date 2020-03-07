import XCTest

@testable import Sudoku;

class BoardDataTests: XCTestCase {

    private var boardData: BoardData!
    
    override func setUp() {
        boardData = BoardData(rows: 2, columns: 2)
        // 1, 2
        // 3, 4
        boardData[0, 0].number = 1
        boardData[0, 1].number = 2
        boardData[1, 0].number = 3
        boardData[1, 1].number = 4
        boardData[0, 0].selected = true
    }
    
    func testGetter() {
        XCTAssertEqual(boardData[0, 0].number, 1)
    }
        
    func testGettingSelectedItem() {
        XCTAssertEqual(boardData.selectedItem(), boardData[0, 0])
    }

    func testDeselection() {
        boardData.deselectAll()
        XCTAssertNil(boardData.selectedItem())
    }
    
    func testNumberAssignment() {
        boardData.assignNumber { ($0 * boardData.columns) + $1 }
        XCTAssertEqual(boardData[0, 0].number, 0)
        XCTAssertEqual(boardData[0, 1].number, 1)
        XCTAssertEqual(boardData[1, 0].number, 2)
        XCTAssertEqual(boardData[1, 1].number, 3)
    }
    
    func testRowGetter() {
        let row_0 = boardData.row(at: 0)
        XCTAssertEqual(row_0[0].number, 1)
        XCTAssertEqual(row_0[1].number, 2)

        let row_1 = boardData.row(at: 1)
        XCTAssertEqual(row_1[0].number, 3)
        XCTAssertEqual(row_1[1].number, 4)
    }
    
    func testColumnGetter() {
        let column_0 = boardData.column(at: 0)
        XCTAssertEqual(column_0[0].number, 1)
        XCTAssertEqual(column_0[1].number, 3)

        let column_1 = boardData.column(at: 1)
        XCTAssertEqual(column_1[0].number, 2)
        XCTAssertEqual(column_1[1].number, 4)
    }
}
