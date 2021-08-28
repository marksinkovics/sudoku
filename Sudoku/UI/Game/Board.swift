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
    var longTapAction: (_ frame: CGRect) -> Void = { _ in }
    
    init(controller: GameController) {
        self.controller = controller
        self.boardData = controller.data
    }
    

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 3, columns: 3, spacing: 4) { outerRow, outerColumn in
                GridStack(rows: 3, columns: 3) { row, column in
                    BoardCell(item: self.boardData[ (3 * outerRow) + row, (3 * outerColumn) + column])
                        .action() { type, frame in
                            let selecterRow = (3 * outerRow) + row
                            let selectedColumn = (3 * outerColumn) + column
                            self.controller.select(row: selecterRow, column: selectedColumn)
                            if type == .long || type == .double {
                                self.longTapAction(frame)
                            }
                        }
                }
            }
        }
        .scaledToFill()
    }
    
    func hightlightRow(_ value: Bool) -> Self {
        self.controller.highlightRow = value
        return self
    }
    
    func hightlightColumn(_ value: Bool) -> Self {
        self.controller.highlightColumn = value
        return self
    }
    
    func hightlightBlock(_ value: Bool) -> Self {
        self.controller.highlightBlock = value
        return self
    }

    
    func longTap(action: @escaping (_ frame: CGRect) -> Void) -> Self {
        var copy = self
        copy.longTapAction = action
        return copy
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Board(controller: controller)
    }
}
