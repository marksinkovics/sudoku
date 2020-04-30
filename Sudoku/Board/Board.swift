import SwiftUI

struct Board: View {
    
    let controller: GameController
    @ObservedObject var boardData: BoardData
    
    init(controller: GameController) {
        self.controller = controller
        self.boardData = controller.data
    }

    var body: some View {
        
        GridStack(rows: 3, columns: 3) { outerRow, outerColumn in
            GridStack(rows: 3, columns: 3) { row, column in
                BoardCell(item: self.boardData[ (3 * outerRow) + row, (3 * outerColumn) + column])
                    .onTapGesture {
                        let selecterRow = (3 * outerRow) + row
                        let selectedColumn = (3 * outerColumn) + column
                        self.controller.select(row: selecterRow, column: selectedColumn)
                }
            }.padding(2)
        }
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Board(controller: controller)
    }
}
