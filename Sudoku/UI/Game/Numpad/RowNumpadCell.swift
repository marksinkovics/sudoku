import SwiftUI

struct RowNumpadCellButtonStyle: ButtonStyle {
    let hidden: Bool
    let selected: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Rectangle()
            .fill((configuration.isPressed && !self.hidden) ? Color.sHighlighted : Color.sBackground)
            .border(self.selected ? Color.sSelected : Color.sText, width: self.selected ? 4 : 1)
            .overlay(configuration.label)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct RowNumpadCell: View {

    @EnvironmentObject var controller: GameController
    @ObservedObject var item: NumpadItem
    
    init(item: NumpadItem) {
        self.item = item
    }
    
    var action: () -> Void {
        return {
            
            guard !self.item.hidden else { return }
            
            switch self.item.value {
                case .number(let number):
                    self.controller.set(number: number)
            }
        }
    }
            
    var body: some View {
        Button(action: self.action) {
            Text(self.item.text)
                .font(Font.title)
                .foregroundColor(self.item.hidden ? Color.sFixed : Color.sText)
        }
        .buttonStyle(RowNumpadCellButtonStyle(hidden: self.item.hidden, selected: self.item.selected))
    }
}

struct NumpadCell_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Group {
            RowNumpadCell(item: NumpadItem(value: .number(1)))
                .environmentObject(controller)
                .frame(width: 80, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}
