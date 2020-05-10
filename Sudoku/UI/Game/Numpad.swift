import SwiftUI

struct NumpadButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(configuration.isPressed ? Color("highlighted_color") : Color("background_color"))
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
            GridStack(rows: 1, columns: 9) { row, column in
                Button(action: {
                    self.controller.set(number: column + 1)
                }) {
                    Text("\(column + 1)")
                        .font(Font.largeTitle)
                        .foregroundColor(Color("text_color"))
                        .frame(width: (geometry.size.width / 9),
                            height: (geometry.size.width / 9),
                            alignment: .center)
                }.buttonStyle(NumpadButtonStyle())
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
