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
            VStack {
                Board(controller: controller)
                    .hightlightRow(userSettings.higlightRow)
                    .hightlightColumn(userSettings.highlightColumn)
                    .hightlightBlock(userSettings.highlightBlock)
                    .longTap { frame in
                        self.showFloatingMenuFrame = frame
                        self.showFloatingMenu.toggle()
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if self.userSettings.numpadType == .full {
                    Numpad(controller: controller)
                        .aspectRatio(7/4, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
                Spacer()
            }
            .padding([.horizontal])
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
            
            if showFloatingMenu && userSettings.numpadType == .floating {
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
        .navigationBarTitle(controller.data.difficulty.description, displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    self.controller.solve()
                }, label: {
                    Image(systemName: "wand.and.stars")
                })
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    self.controller.shouldResettingAlert = true
                }, label: {
                    Image(systemName: "arrow.counterclockwise")
                })
                                
                Spacer()

                Button(action: {
                    self.controller.delete()
                }, label: {
                    Image(systemName: "arrow.uturn.left")
                })

                
                Spacer()

                Button(action: {
                    self.controller.draft.toggle()
                }, label: {
                    Image(systemName: self.controller.draft ? "pencil.circle.fill" : "pencil.circle")
                })
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
