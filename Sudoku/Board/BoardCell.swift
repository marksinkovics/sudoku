import SwiftUI

struct BoardCell: View {
    
    @ObservedObject var item: Item
    
    func backgroundColor() -> Color {
        item.highlighted ? Color(.systemTeal).opacity(0.3) : Color(.systemFill)
    }
    
    func textColor() -> Color {
        item.fixed ? Color(.secondaryLabel) : Color(.label)
    }
        
    func borderColor() -> Color {
        item.selected ? Color(.systemRed) : Color.black
    }
    
    func borderSize() -> CGFloat {
        item.selected ? 4 : 1
    }
            
    var body: some View {
        GeometryReader { geometry in
            Text(self.item.str)
                .font(Font.system(size: 30))
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
