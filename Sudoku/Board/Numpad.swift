import SwiftUI

struct Numpad: View {
    
    let sudoku: Sudoku
    
    init(sudoku: Sudoku) {
        self.sudoku = sudoku
    }

    var numpadItems = Array(1...9).map { Item(number: $0) }
        
    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 1, columns: self.numpadItems.count) { row, column in
                BoardCell(item: self.numpadItems[column])
                    .onTapGesture {
                        self.sudoku.set(number: self.numpadItems[column].number)
                    }
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var sudoku: Sudoku = Sudoku()

    static var previews: some View {
        Numpad(sudoku: sudoku)
    }
}
