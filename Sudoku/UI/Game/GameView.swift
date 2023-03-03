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
    
    struct AlertInfo: Identifiable {
        enum AlertType {
            case none
            case solveAll
            case reset
        }
        let id: AlertType
    }
        
    @ObservedObject var controller: GameController
    @AppStorage(UserSettings.Keys.numpadType.rawValue) var numpadType: UserSettings.NumpadType = .row
    @State var showingCongratsToast: Bool = false
    @State var alertInfo: AlertInfo? = nil
    
    @State private var boardMaxWidth: CGFloat?
        
    public init(state: GameInitialState) {
        self.controller = GameController()
        if case .new(let difficulty) = state {
            self.controller.generate(difficulty: difficulty)
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
                    .aspectRatio(1.0, contentMode: .fit)
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) {
                        boardMaxWidth = $0
                    }
                Spacer()
                if numpadType == .row {
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
                        .foregroundColor(Color.App.Game.toolbarIcon)
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
