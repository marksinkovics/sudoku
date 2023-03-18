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

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: Value = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct GameView: View {
    
    struct AlertInfo: Identifiable {
        enum AlertType {
            case none
            case solveAll
            case reset
        }
        let id: AlertType
    }
        
    @State var showingCongratsToast: Bool = false
    @State var alertInfo: AlertInfo? = nil
    
    @State private var boardMaxWidth: CGFloat?

    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var history: History
    @EnvironmentObject var controller: GameController

    let initialState: GameInitialState

    public init(state: GameInitialState) {
        self.initialState = state
    }

    func prepareBoard() async {
        if case .continue = self.initialState {
            self.controller.data = history.items.first!
        } else if case .new(let difficulty) = self.initialState {
            self.controller.generate(difficulty: difficulty)
            history.set(data: self.controller.data)
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.App.background)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Board()
                    .aspectRatio(1.0, contentMode: .fit)
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) {
                        boardMaxWidth = $0
                    }
                Spacer()
                if userSettings.numpadType == .row {
                    RowNumpad()
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .padding([.top], 20)
                        .padding([.bottom], 40)
                        .frame(maxWidth: boardMaxWidth)
                }
                HStack {
                    Button(action: {
                        self.controller.shouldResettingAlert = true
                    }, label: {
                        ToolBarItem(text: "Reset all", systemName: "trash")
                            .foregroundStyle(Color.App.Game.toolbarTrash)
                    })
                    Spacer()
                    Button(action: self.controller.delete, label: {
                        ToolBarItem(text: "Erase", systemName: "eraser.line.dashed")
                            .foregroundStyle(.cyan, .yellow)
                    })
                    Spacer()
                    Button(action: {
                        self.controller.draft.toggle()
                    }, label: {
                        if self.controller.draft {
                            ToolBarItem(text: "Draft", systemName: "square.and.pencil")
                                .foregroundStyle(.yellow, Color.App.Game.toolbarRed)
                        } else {
                            ToolBarItem(text: "Final", systemName: "pencil.line")
                                .foregroundStyle(.yellow, Color.App.Game.toolbarRed)
                        }
                    })
                }
                .padding([.leading, .trailing], 15)
                .frame(height: 55)
                .background(Color.clear)
            }
            .padding([.horizontal])
            .onReceive(controller.$finished) {
                self.showingCongratsToast = $0
                self.alertInfo = nil
            }
            .onReceive(controller.$shouldResettingAlert) {
                if $0 {
                    self.alertInfo = AlertInfo(id: .reset)
                }
                self.showingCongratsToast = false
            }
            .toast(isPresenting: $showingCongratsToast, toast: { ConfettiToast(title: "Congrats!!!") })
        }
        .navigationBarTitle(controller.data.difficulty.description, displayMode: .inline)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    self.alertInfo = AlertInfo(id: .solveAll)
                }, label: {
                    Image(systemName: "wand.and.stars")
                        .foregroundStyle(Color.App.Game.toolbarWand, .purple)
                })
            }
        }
        .alert(item: $alertInfo) { info in
            if info.id == .solveAll {
                return Alert(title: Text("Solve"),
                             message: Text("Are you sure you want to auto-solve it all? It cannot be undone."),
                             primaryButton: .default(Text("Solve"), action: { self.controller.solve() }),
                             secondaryButton: .cancel { self.alertInfo = nil } )
            }
            
            return Alert(title: Text("Reset the game board"),
                         message: Text("Are you sure you want to reset the game board? It cannot be undone."),
                         primaryButton: .destructive(Text("Reset"), action: { self.controller.reset() }),
                         secondaryButton: .cancel { self.controller.shouldResettingAlert = false } )
        }.task {
            await prepareBoard()
        }.onDisappear {
            history.save()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    private static let userSettings = UserSettings()
    private static let history = History()

    static var previews: some View {
        GameView(state: .new(difficulty: .easy))
            .environmentObject(userSettings)
            .environmentObject(history)
            .preferredColorScheme(.dark)
    }
}
