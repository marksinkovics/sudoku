import SwiftUI

struct Board: View {
    
    @ObservedObject var boardData: BoardData

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 9, columns: 9) { row, column in
                BoardCell(item: self.boardData[row, column])
                    .onTapGesture {
                        self.boardData.deselectAll()
                        self.boardData[row, column].selected = true
                }
            }
        }
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var boardData: BoardData = BoardData()

    static var previews: some View {
        Board(boardData: boardData)
    }
}
