import SwiftUI

struct Numpad: View {
    
    let controller: GameController
    let spacing: CGFloat = 4
    
    init(controller: GameController) {
        self.controller = controller
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: self.spacing) {
                HStack(alignment: .center, spacing: self.spacing) {
                    VStack(alignment: .center, spacing: self.spacing) {
                        NumpadCell(item: self.controller.numpadItemNormal, controller: self.controller)
                            .aspectRatio(3/1, contentMode: .fit)
                        NumpadCell(item: self.controller.numpadItemDraft, controller: self.controller)
                            .aspectRatio(3/1, contentMode: .fit)
                        NumpadCell(item: NumpadItem(value: .solve), controller: self.controller)
                            .aspectRatio(3/1, contentMode: .fit)
                    }
                    GridStack(rows: 3, columns: 3, spacing: self.spacing) { row, column in
                        NumpadCell(item: self.controller.numpadItems[3 * row + column], controller: self.controller)
                            .aspectRatio(1, contentMode: .fit)
                    }
                    NumpadCell(item: NumpadItem(value: .delete), controller: self.controller)
                        .aspectRatio(1/3, contentMode: .fit)
                }
                NumpadCell(item: NumpadItem(value: .reset), controller: self.controller)
                    .aspectRatio(7/1, contentMode: .fit)
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
