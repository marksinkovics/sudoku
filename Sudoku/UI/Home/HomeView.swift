import SwiftUI

struct HomeView: View {
    
    
    @State var isActive: Bool = false
    @State var isContinueActive: Bool = false

    func hasSavedGame() -> Bool {
        return UserDefaults.standard.data(forKey: "saved") != nil
    }

    
    var body: some View {
        ZStack {
            Color.sBackground.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 60) {
                NavigationLink(destination: LevelView(shouldPopToRootView: self.$isActive), isActive: self.$isActive) {
                    MenuItemView("New game")
                }.isDetailLink(false)
                NavigationLink(destination: LazyView { GameView(state: .`continue`, shouldPopToRootView: self.$isActive)}) {
                    MenuItemView("Continue", enabled: isContinueActive)
                }.isDetailLink(false)
                .disabled(!isContinueActive)
                NavigationLink(destination: SettingsView()) {
                    MenuItemView("Settings")
                }.isDetailLink(false)
            }
        }
        .edgesIgnoringSafeArea(.all)
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
