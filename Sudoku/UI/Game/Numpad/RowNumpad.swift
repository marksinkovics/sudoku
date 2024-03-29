import SwiftUI

struct RowNumpad: View {

    @EnvironmentObject var controller: GameController

    let spacing: CGFloat = 4
    
    var body: some View {
        HStack {
            ForEach(0..<9, id: \.self) { index in
                RowNumpadCell(item: self.controller.numpadItems[index])
                        .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        RowNumpad()
            .environmentObject(controller)
            .aspectRatio(7/4, contentMode: .fit)
    }
}
