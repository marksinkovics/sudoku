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
    @State var showingCongratsToast: Bool = false
    @State var showingResettingAlert: Bool = false
    @State var showingSolveAllAlert: Bool = false
    
    @State private var boardMaxWidth: CGFloat?
        
    public init(state: GameInitialState) {
        if state == .continue, let data = GameController.lastSavedGame {
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
            Rectangle()
                .fill(Color.App.background)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Board(controller: controller)
                    .hightlightRow(userSettings.higlightRow)
                    .hightlightColumn(userSettings.highlightColumn)
                    .hightlightBlock(userSettings.highlightBlock)
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
                HStack {
                    Button(action: {
                        self.controller.shouldResettingAlert = true
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(Color.App.Game.toolbarIcon)
                    })
                    .alert(isPresented: $showingResettingAlert) {
                        return Alert(title: Text("Reset the game board"),
                                     message: Text("Are you sure you want to reset the game board? It cannot be undone."),
                                     primaryButton: .destructive(Text("Reset"), action: { self.controller.reset() }),
                                     secondaryButton: .cancel { self.controller.shouldResettingAlert = false } )
                    }
                    Spacer()
                    Button(action: {
                        self.controller.delete()
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(Color.App.Game.toolbarIcon)
                    })
                    Spacer()
                    Button(action: {
                        self.controller.draft.toggle()
                    }, label: {
                        Image(systemName: self.controller.draft ? "pencil.circle.fill" : "pencil.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundColor(Color.App.Game.toolbarIcon)
                    })
                }
                .padding([.leading, .trailing], 15)
                .frame(height: 55)
                .background(Color.clear)
            }
            .padding([.horizontal])
            .onReceive(controller.$finished) {
                self.showingCongratsToast = $0
                self.showingResettingAlert = false
        
            }
            .onReceive(controller.$shouldResettingAlert) {
                self.showingResettingAlert = $0
                self.showingCongratsToast = false
            }
            .toast(isPresenting: $showingCongratsToast, toast: { ConfettiToast(title: "Congrats!!!") })
        }
        .navigationBarTitle(controller.data.difficulty.description, displayMode: .inline)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    self.showingSolveAllAlert = true
                }, label: {
                    Image(systemName: "wand.and.stars")
                        .foregroundColor(Color.App.Game.toolbarIcon)
                })
                .alert(isPresented: $showingSolveAllAlert) {
                    return Alert(title: Text("Solve"),
                                 message: Text("Are you sure you want to auto-solve it all? It cannot be undone."),
                                 primaryButton: .default(Text("Solve"), action: { self.controller.solve() }),
                                 secondaryButton: .cancel { self.showingSolveAllAlert = false } )
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
