import SwiftUI

struct BoardCell: View {
    
    @ObservedObject var item: Item
    
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
            Text(self.item.str)
                .font(Font.system(size: 30))
                .fontWeight(.semibold)
                .foregroundColor(self.textColor())
                .frame(width: geometry.size.width, height: geometry.size.height)
                .border(self.borderColor(), width: self.borderSize())
                .background(self.backgroundColor())
        }
    }
}

struct BoardCell_Previews: PreviewProvider {
    
    private static var item: Item = Item()

    static var previews: some View {
        BoardCell(item: item)
    }
}
