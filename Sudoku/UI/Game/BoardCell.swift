import SwiftUI

struct BoardCell: View {

    @ObservedObject var item: Item
    let row: Int
    let column: Int

    var action: () -> Void = {}

    init(item: Item, row: Int, column: Int, action: @escaping () -> Void = {}) {
        self.item = item
        self.row = row
        self.column = column
        self.action = action
    }

    func backgroundColor() -> Color {
        if item.error {
            return .sError
        }
        
        if item.highlighted {
            return .sHighlighted
        }
        
        return .sBackground
    }

    func textColor() -> Color {
        item.fixed ? .sFixed  : .sText
    }
    
    func borderColor() -> Color {
        item.selected ? .sSelected : .sText
    }
    
    func borderSize() -> CGFloat {
        item.selected ? 4 : 1
    }

    func calculateEdges() -> [Edge] {
        if (item.selected) {
            return [.top, .bottom, .leading, .trailing]
        }
        var edges: [Edge] = []

        if (row) % 3 == 0 {
            edges.append(.top)
        }

        if (row + 1) % 3 == 0 {
            edges.append(.bottom)
        }

        if (column) % 3 == 0 {
            edges.append(.leading)
        }

        if (column + 1) % 3 == 0 {
            edges.append(.trailing)
        }
        return edges
    }

    var body: some View {
        ZStack {
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(0..<3) { row in
                    GridRow {
                        ForEach(0..<3) { column in
                            DraftCell(item: self.item.draftNumbers[3 * row + column])
                        }
                    }
                }
            }
            .padding(5)
            Text(self.item.str)
                .font(Font.system(size: 30))

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(self.textColor())
        .border(width: 1, edges: [.top, .bottom, .leading, .trailing], color: .sText)
        .border(width: borderSize(), edges: calculateEdges(), color: borderColor())
        .background(self.backgroundColor())
        .onTapGesture {
            self.action()
        }
    }
    
    func action(action: @escaping () -> Void) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}

struct BoardCell_Previews: PreviewProvider {
    
    private static var item: Item = Item(number: 1)
    private static var item2: Item = Item(number: 0, draftNumbers: [
        DraftItem(number: 1, hidden: false),
        DraftItem(number: 2, hidden: true),
        DraftItem(number: 3, hidden: true),
        DraftItem(number: 4, hidden: false),
        DraftItem(number: 5, hidden: true),
        DraftItem(number: 6, hidden: true),
        DraftItem(number: 7, hidden: true),
        DraftItem(number: 8, hidden: false),
        DraftItem(number: 9, hidden: true)

    ])

    static var previews: some View {
        Group {
            BoardCell(item: item, row: 1, column: 1)
                .frame(width: 40, height: 40)
                .previewLayout(.sizeThatFits)
            BoardCell(item: item2, row: 1, column: 1)
                .frame(width: 40, height: 40)
                .previewLayout(.sizeThatFits)

        }
    }
}
