import SwiftUI

struct HomeView: View {
    
    enum MenuItems: Hashable {
        case easy
        case medium
        case hard
        case expert
        case `continue`
        case settings
    }
    
    @State var isActive: Bool = false
    @State var isContinueActive: Bool = false
    @State var navigationTagIndex: MenuItems? = nil
    @State var showingActionSheet: Bool = false
    
    func hasSavedGame() -> Bool {
        return GameController.load() != nil
    }
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.sText
    }
        
    var body: some View {
        ZStack {
            Color.sBackground.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 0) {
                MenuItemView("New game") { self.showingActionSheet = true }
                    .padding(30)
                MenuItemView("Continue", enabled: self.$isContinueActive) { self.navigationTagIndex = .continue }
                    .padding(30)
                MenuItemView("Settings") { self.navigationTagIndex = .settings }
                    .padding(30)
                
                NavigationLink(
                    destination: LazyView { GameView(state: .new(difficulty: .easy))},
                    tag: MenuItems.easy,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                NavigationLink(
                    destination: LazyView { GameView(state: .new(difficulty: .medium))},
                    tag: MenuItems.medium,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                NavigationLink(
                    destination: LazyView { GameView(state: .new(difficulty: .hard))},
                    tag: MenuItems.hard,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                NavigationLink(
                    destination: LazyView { GameView(state: .new(difficulty: .expert))},
                    tag: MenuItems.expert,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                NavigationLink(
                    destination: LazyView { GameView(state: .`continue`)},
                    tag: MenuItems.continue,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                NavigationLink(
                    destination: LazyView { SettingsView()},
                    tag: MenuItems.settings,
                    selection: $navigationTagIndex
                ) { EmptyView() }
                
            }.actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Select the difficulty level"), buttons: [
                    .default(Text("Easy")) { self.navigationTagIndex = .easy },
                    .default(Text("Medium")) { self.navigationTagIndex = .medium },
                    .default(Text("Hard")) { self.navigationTagIndex = .hard },
                    .default(Text("Expert")) { self.navigationTagIndex = .expert },
                    .cancel()
                ])
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(false)
        .onAppear {
            self.isContinueActive = self.hasSavedGame()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
