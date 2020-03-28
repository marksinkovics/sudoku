import SwiftUI

struct Board: View {
    
    let sudoku: Sudoku
    @ObservedObject var boardData: BoardData
    
    init(sudoku: Sudoku) {
        self.sudoku = sudoku
        self.boardData = sudoku.data
    }

    var body: some View {
        GridStack(rows: 3, columns: 3) { outerRow, outerColumn in
            GridStack(rows: 3, columns: 3) { row, column in
                BoardCell(item: self.boardData[ (3 * outerRow) + row, (3 * outerColumn) + column])
                    .onTapGesture {
                        let selecterRow = (3 * outerRow) + row
                        let selectedColumn = (3 * outerColumn) + column
                        self.sudoku.select(row: selecterRow, column: selectedColumn)
                }
            }.padding(2)
        }
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var sudoku: Sudoku = Sudoku()

    static var previews: some View {
        Board(sudoku: sudoku)
    }
}
