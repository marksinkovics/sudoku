import SwiftUI
    
enum GameInitialState: Equatable {
    case new(difficulty: BoardData.Difficulty)
    case `continue`
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.new(let difficulty1), .new(let difficulty2)):
            return difficulty1 == difficulty2
        case (.`continue`, .`continue`):
            return true
        default:
            return false
        }
    }

}

struct GameView: View {
        
    @ObservedObject var controller: GameController
    @EnvironmentObject var userSettings: UserSettings
    
    public init(controller: GameController = GameController(), state: GameInitialState) {
        self.controller = controller

        if state == .continue {
            self.controller.load()
        } else if case .new(let difficulty) = state {
            self.controller.generate(difficulty: difficulty)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(controller.finished ? "Congratulation" : "Sudoku")
                .foregroundColor(Color.sText)
                .background(Color.sBackground)
            HStack {
                Text("\(controller.data.difficulty.description)")
                Spacer()
            }
            .padding([.leading, .trailing, .top])
            .padding([.bottom], 4)
            .frame(maxWidth: .infinity, maxHeight: 10, alignment: .center)
            Board(controller: controller)
                .hightlightRow(userSettings.higlightRow)
                .hightlightColumn(userSettings.highlightColumn)
                .hightlightNeighborhood(userSettings.highlightNeighborhood)
                .aspectRatio(1.0, contentMode: .fit)
                .padding([.leading, .trailing, .bottom])
            Numpad(controller: controller)
                .aspectRatio(7/4, contentMode: .fit)
                .padding(.horizontal)
                .padding(.top)
            Spacer()
        }
        .background(Color.sBackground)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(label: "Home"){
//            self.presentationMode.wrappedValue.dismiss()
//        })
    }
}

struct GameView_Previews: PreviewProvider {
    private static var controller: GameController = GameController()

    static var previews: some View {
        GameView(state: .new(difficulty: .easy))
        .environment(\.colorScheme, .dark)
    }
}
