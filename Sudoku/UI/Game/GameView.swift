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
    @State var boardWidth: CGFloat = 0
    @State var showingAlert: Bool = false
    @State var showingCongratsAlert: Bool = false
    @State var showingResettingAlert: Bool = false
    @State var showFloatingMenu: Bool = false
    @State var showFloatingMenuFrame: CGRect = .zero
    
    public init(state: GameInitialState) {
        if state == .continue, let data = GameController.load() {
            self.controller = GameController(boardData: data)
        } else if case .new(let difficulty) = state {
            self.controller = GameController()
            self.controller.generate(difficulty: difficulty)
        } else {
            self.controller = GameController()
            self.controller.generate(difficulty: .easy)
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Spacer(minLength: 64)
                    HStack {
                        Text("\(controller.data.difficulty.description)")
                        Spacer()
                    }
                    .frame(width: boardWidth)
                    Board(controller: controller, boardWidth: self.$boardWidth)
                        .hightlightRow(userSettings.higlightRow)
                        .hightlightColumn(userSettings.highlightColumn)
                        .hightlightBlock(userSettings.highlightBlock)
                        .longTap { frame in
                            self.showFloatingMenuFrame = frame
                            self.showFloatingMenu.toggle()
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .padding([.bottom])
                        .frame(maxWidth: .infinity)
                    Numpad(controller: controller)
                        .aspectRatio(7/4, contentMode: .fit)
                        .frame(width: boardWidth)
                    Spacer()
                }
                .padding([.horizontal])
                .background(Color.sBackground)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .onReceive(controller.$finished) {
                    self.showingCongratsAlert = $0
                    self.showingResettingAlert = false
                    self.showingAlert = $0
                }
                .onReceive(controller.$shouldResettingAlert) {
                    self.showingResettingAlert = $0
                    self.showingCongratsAlert = false
                    self.showingAlert = $0
                }
                .alert(isPresented: $showingAlert) {
                    if self.showingResettingAlert {
                        return Alert(title: Text("Reset the game board"),
                                     message: Text("Are you sure you want to reset the game board? It cannot be undone."),
                                     primaryButton: .destructive(Text("Reset"), action: { self.controller.reset() }),
                                     secondaryButton: .default(Text("Cancel"), action: { self.controller.shouldResettingAlert = false }))
                    }
                                
                    return Alert(title: Text("Congratulations 🎉"),
                                 message: Text("You solved this Sudoku\non level \(controller.data.difficulty.description) 👏"))
                }
            }
            if showFloatingMenu {
                FloatingMenu(frame: self.showFloatingMenuFrame)
                    .dismiss {
                        self.showFloatingMenu.toggle()
                    }
                    .selected { key in
                        if case .numpad(let value) = key {
                            self.controller.set(number: value)
                        } else {
                            self.controller.delete()
                        }
                    }
            }

        }
    }
}

struct GameView_Previews: PreviewProvider {
    private static let userSettings = UserSettings()

    static var previews: some View {
        GameView(state: .new(difficulty: .easy))
        .environmentObject(userSettings)
        .preferredColorScheme(.dark)
    }
}
