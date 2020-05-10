import SwiftUI

struct BoardCell: View {
    
    @ObservedObject var item: Item
    
    func backgroundColor() -> Color {
        if item.error {
            return Color(.red).opacity(0.4)
        }
        if item.highlighted {
            return Color("highlighted_color")
        }
        return Color("background_color")
    }
        
    func textWeight() -> Font.Weight {
        item.fixed ? .bold : .regular
    }
    
    func borderColor() -> Color {
        item.selected ? Color("selected_color") : Color("text_color")
    }
    
    func borderSize() -> CGFloat {
        item.selected ? 4 : 1
    }
            
    var body: some View {
        GeometryReader { geometry in
            Text(self.item.str)
                .font(Font.system(size: 30))
                .fontWeight(self.textWeight())
                .foregroundColor(Color("text_color"))
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
