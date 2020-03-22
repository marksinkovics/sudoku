import SwiftUI

struct Numpad: View {
    
    @ObservedObject var boardData: BoardData
    
    var numpadItems = Array(1...9).map { Item(number: $0) }
        
    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 1, columns: self.numpadItems.count) { row, column in
                BoardCell(item: self.numpadItems[column])
                    .onTapGesture {
                        self.boardData.selectedItem()?.number = self.numpadItems[column].number
                    }
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var boardData: BoardData = BoardData()

    static var previews: some View {
        Numpad(boardData: boardData)
    }
}
