import SwiftUI

struct GameView: View {
    @ObservedObject var controller: GameController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init(controller: GameController = GameController(), newGame: Bool = true) {
        self.controller = controller
        if newGame {
            self.controller.generate()
        } else {
            self.controller.load()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(controller.finished ? "Congratulation" : "Sudoku")
                .foregroundColor(Color.sText)
                .background(Color.sBackground)
            Board(controller: controller)
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
            Numpad(controller: controller)
                .aspectRatio(7/4, contentMode: .fit)
                .padding(.horizontal)
                .padding(.top)
            Spacer()
        }
        .background(Color.sBackground)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(label: "Home"){
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}

struct GameView_Previews: PreviewProvider {
    private static var controller: GameController = GameController()

    static var previews: some View {
        GameView()
        .environment(\.colorScheme, .dark)
    }
}
