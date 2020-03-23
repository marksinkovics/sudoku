import SwiftUI

struct Board: View {
    
    let sudoku: Sudoku
    @ObservedObject var boardData: BoardData
    
    init(sudoku: Sudoku) {
        self.sudoku = sudoku
        self.boardData = sudoku.data
    }

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 9, columns: 9) { row, column in
                BoardCell(item: self.boardData[row, column])
                    .onTapGesture {
                        self.sudoku.select(item: self.boardData[row, column], atRow: row, column: column)
                }
            }
        }
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var sudoku: Sudoku = Sudoku()

    static var previews: some View {
        Board(sudoku: sudoku)
    }
}
