import SwiftUI

struct BoardWidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Board: View {
    
    let controller: GameController
    @ObservedObject var boardData: BoardData
    @Binding var boardWidth: CGFloat
    
    init(controller: GameController, boardWidth: Binding<CGFloat>) {
        self.controller = controller
        self.boardData = controller.data
        self._boardWidth = boardWidth
    }

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 3, columns: 3, spacing: 4) { outerRow, outerColumn in
                GridStack(rows: 3, columns: 3) { row, column in
                    BoardCell(item: self.boardData[ (3 * outerRow) + row, (3 * outerColumn) + column])
                        .onTapGesture {
                            let selecterRow = (3 * outerRow) + row
                            let selectedColumn = (3 * outerColumn) + column
                            self.controller.select(row: selecterRow, column: selectedColumn)
                    }
                }
            }
            .preference(key: BoardWidthPreferenceKey.self, value: geometry.size.width)
        }
        .scaledToFill()
        .onPreferenceChange(BoardWidthPreferenceKey.self) {
            self.boardWidth = $0
        }
    }
    
    func hightlightRow(_ value: Bool) -> Self {
        self.controller.highlightRow = value
        return self
    }
    
    func hightlightColumn(_ value: Bool) -> Self {
        self.controller.highlightColumn = value
        return self
    }
    
    func hightlightNeighborhood(_ value: Bool) -> Self {
        self.controller.highlightNeighborhood = value
        return self
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Board(controller: controller, boardWidth: .constant(0))
    }
}
