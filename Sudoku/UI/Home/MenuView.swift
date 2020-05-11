import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.sBackground.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 60) {
                    NavigationLink(destination: LazyView { GameView(newGame: true)}) {
                        MenuItemView("New game")
                    }
                    NavigationLink(destination: LazyView { GameView(newGame: false)} ) {
                        MenuItemView("Continue")
                    }
                    NavigationLink(destination: SettingsView()) {
                        MenuItemView("Settings")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
         .environment(\.colorScheme, .dark)
    }
}
