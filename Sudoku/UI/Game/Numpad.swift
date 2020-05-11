import SwiftUI

struct NumpadButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(configuration.isPressed ? Color.sHighlighted : Color.sBackground)
            .overlay(configuration.label)
    }
}

struct Numpad: View {
    
    let controller: GameController
    
    init(controller: GameController) {
        self.controller = controller
    }

    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 1, columns: self.controller.numpadItems.count) { row, column in
                NumpadCell(item: self.controller.numpadItems[column], controller: self.controller)
                    .frame(width: (geometry.size.width / 9),
                        height: (geometry.size.width / 9),
                        alignment: .center)
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Numpad(controller: controller)
    }
}
