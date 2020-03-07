import SwiftUI

struct Board: View {
    
    @EnvironmentObject var boardData: BoardData

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 9, columns: 9) { row, column in
                BoardCell()
                    .environmentObject(self.boardData[row, column])
                    .onTapGesture {
                        self.boardData.deselectAll()
                        self.boardData[row, column].selected = true
                }
            }
        }
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var boardData: BoardData = BoardData(rows: 9, columns: 9)

    static var previews: some View {
        Board()
            .environmentObject(boardData)
    }
}
