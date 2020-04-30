import SwiftUI

struct Numpad: View {
    
    let controller: GameController
    
    init(controller: GameController) {
        self.controller = controller
    }

    var numpadItems = Array(1...9).map { Item(number: $0) }
        
    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 1, columns: self.numpadItems.count) { row, column in
                BoardCell(item: self.numpadItems[column])
                    .onTapGesture {
                        self.controller.set(number: self.numpadItems[column].number)
                    }
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
