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

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear
                .anchorPreference(key: SizePreferenceKey.self, value: .bounds) { anchor in geometry[anchor].size.width }
        }
    }

    func body(content: Content) -> some View {
        content.overlay(sizeView)
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
    
    @State private var boardMaxWidth: CGFloat?
        
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
                Spacer()
                Board(controller: controller)
                    .hightlightRow(userSettings.higlightRow)
                    .hightlightColumn(userSettings.highlightColumn)
                    .hightlightBlock(userSettings.highlightBlock)
                    .longTap { frame in
                        self.showFloatingMenuFrame = frame
                        self.showFloatingMenu.toggle()
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) {
                        boardMaxWidth = $0
                    }
                Spacer()
                if self.userSettings.numpadType == .row {
                    RowNumpad(controller: controller)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .padding([.top], 20)
                        .padding([.bottom], 40)
                        .frame(maxWidth: boardMaxWidth)
                }
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
            
            if showFloatingMenu && userSettings.numpadType == .arc {
                ArcNumpad(frame: self.showFloatingMenuFrame)
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
//                    Image(systemName: "arrow.uturn.left")
                    Image(systemName: "trash")
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
