import SwiftUI

struct GameView: View {
    @ObservedObject var controller: GameController
    
    public init(controller: GameController) {
        self.controller = controller
        self.controller.generate()
    }
    
    var body: some View {
        VStack {
            Text(controller.finished ? "Congratulation" : "Sudoku")
            Spacer()
            Board(controller: controller)
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
            Spacer()
            Numpad(controller: controller)
                .aspectRatio(9/1, contentMode: .fit)
                .padding(.leading)
                .padding(.trailing)
            Spacer()
            HStack(alignment: .center) {
                Text("Generate")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.controller.generate() }
                    .frame(width: 80)
                Text("Solve")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.controller.solve() }
                    .frame(width: 80)
                Text("Clear All")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.controller.clearAll() }
                    .frame(width: 80)
                Text("Clear")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.controller.clearSelected() }
                    .frame(width: 80)

            }
            Spacer()
        }.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct GameView_Previews: PreviewProvider {
    private static var controller: GameController = GameController()

    static var previews: some View {
        GameView(controller: GameController())
    }
}
