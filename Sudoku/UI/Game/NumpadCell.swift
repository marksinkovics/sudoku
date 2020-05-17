import SwiftUI

struct NumpadCellButtonStyle: ButtonStyle {
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


typealias NumpadCellAction = (NumpadItem) -> Void

struct NumpadCell: View {
    
    @ObservedObject var item: NumpadItem
    var controller: GameController
    
    init(item: NumpadItem, controller: GameController) {
        self.controller = controller
        self.item = item
    }
    
    var action: () -> Void {
        return {
            
            guard !self.item.hidden else { return }
            
            switch self.item.value {
                case .number(let number):
                    self.controller.set(number: number)
                case .delete:
                    self.controller.clearSelected()
                case .reset:
                    self.controller.clearAll()
                case .solve:
                    self.controller.solve()
                case .normal:
                    self.controller.draft = false
                case .draft:
                    self.controller.draft = true
            }
        }
    }
    
    var font: Font {
        if case .number(_) = item.value {
            return Font.largeTitle
        }
        return Font.title
    }
        
    var body: some View {
        Button(action: self.action) {
            if item.value == .delete {
                Image(systemName: item.value.systemImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.sText)
                    .padding(10)
            } else {
                Text(self.item.text)
                    .font(self.font)
                    .foregroundColor(self.item.hidden ? Color.sFixed : Color.sText)
            }
            
        }
        .buttonStyle(NumpadCellButtonStyle(hidden: self.item.hidden, selected: self.item.selected))
    }
}

struct NumpadCell_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Group {
            NumpadCell(item: NumpadItem(value: .delete), controller: controller)
                .frame(width: 80, height: 80)
                .previewLayout(.sizeThatFits)
            NumpadCell(item: NumpadItem(value: .number(1)), controller: controller)
                .frame(width: 80, height: 80)
                .previewLayout(.sizeThatFits)
            NumpadCell(item: NumpadItem(value: .normal), controller: controller)
                .frame(width: 120, height: 80)
                .previewLayout(.sizeThatFits)
            NumpadCell(item: NumpadItem(value: .normal), controller: controller)
                .frame(width: 120, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}
