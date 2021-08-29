import SwiftUI

struct Numpad: View {
    
    let controller: GameController
    let spacing: CGFloat = 4
    
    init(controller: GameController) {
        self.controller = controller
    }

    var body: some View {
        HStack {
            ForEach(0..<9, id: \.self) { index in
                NumpadCell(item: self.controller.numpadItems[index], controller: self.controller)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Numpad(controller: controller)
            .aspectRatio(7/4, contentMode: .fit)
    }
}
