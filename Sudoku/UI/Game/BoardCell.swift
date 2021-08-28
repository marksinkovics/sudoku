import SwiftUI

struct DraftCell: View {
    
    @ObservedObject var item: DraftItem
    
    var body: some View {
        GeometryReader { gridGeometry in
            Text(self.item.text)
                .font(.system(size: 12))
                .foregroundColor(Color.sFixed)
                .frame(width: gridGeometry.size.width, height: gridGeometry.size.height)
                .isHidden(self.item.hidden)
        }
    }
}

struct BoardCell: View {
    
    public enum ActionType {
        case single
        case double
        case long
    }
    
    @ObservedObject var item: Item
    var action: (ActionType, CGRect) -> Void = { _,_  in }

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
            
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GridStack(rows: 3, columns: 3, spacing: 1) { row, column in
                    DraftCell(item: self.item.draftNumbers[3 * row + column])
                }
                .padding(3)
                Text(self.item.str)
                    .font(Font.system(size: 30))
                    .foregroundColor(self.textColor())
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .border(self.borderColor(), width: self.borderSize())
            }
            .background(self.backgroundColor())
            .simultaneousGesture(LongPressGesture().onEnded { event in
                debugPrint("Long tap")
                self.action(.long, geometry.frame(in: .global))
            })
            .simultaneousGesture(SimultaneousGesture(TapGesture(count: 1), TapGesture(count: 2)).onEnded { gestures in
                if gestures.second != nil {
                    debugPrint("Double tap")
                    self.action(.double, geometry.frame(in: .global))
                } else if gestures.first != nil {
                    debugPrint("Single tap")
                    self.action(.single, geometry.frame(in: .global))
                }
            })
        }
    }
    
    func action(action: @escaping (ActionType, CGRect) -> Void) -> Self {
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
            BoardCell(item: item)
                .frame(width: 40, height: 40)
                .previewLayout(.sizeThatFits)
            BoardCell(item: item2)
                .frame(width: 40, height: 40)
                .previewLayout(.sizeThatFits)

        }
    }
}
