import SwiftUI

extension CGRect {
    var mid: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
}

struct Board: View {
    
    let controller: GameController
    var longTapAction: (_ frame: CGRect) -> Void = { _ in }
    
    init(controller: GameController) {
        self.controller = controller
    }

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 3, columns: 3, spacing: 4, content: { outerRow, outerColumn in
                GridStack(rows: 3, columns: 3) { row, column in
                    GeometryReader { cellGeometry in
                        let selecterRow = (3 * outerRow) + row
                        let selectedColumn = (3 * outerColumn) + column
                        BoardCell(item: self.controller.data[selecterRow, selectedColumn])
                            .action() { type, frame in
                                self.controller.select(row: selecterRow, column: selectedColumn)
                            }
                        }
                }
            })
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
