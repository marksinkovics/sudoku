import SwiftUI



typealias NumpadCellAction = (NumpadItem) -> Void

struct NumpadCell: View {
    
    @ObservedObject var item: NumpadItem
    var controller: GameController
    
    init(item: NumpadItem, controller: GameController) {
        self.controller = controller
        self.item = item
    }
    
    var body: some View {
        Button(action: {
            self.controller.set(number: self.item.number)
        }) {
            Text(self.item.text)
                .font(Font.largeTitle)
                .foregroundColor(Color.sText)
        }
        .buttonStyle(NumpadButtonStyle())
        .isHidden(self.item.hidden)
    }
}

struct NumpadCell_Previews: PreviewProvider {
    
    private static var item: NumpadItem = NumpadItem(number: 1)
    private static var controller: GameController = GameController()

    static var previews: some View {
        NumpadCell(item: item, controller: controller)
    }
}
