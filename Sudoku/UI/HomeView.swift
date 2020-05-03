import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
             VStack(alignment: .center, spacing: 30) {
                NavigationLink(destination: LazyView { GameView(newGame: true)} ) {
                    Text("New game")
                }.buttonStyle(PlainButtonStyle())
                NavigationLink(destination: LazyView { GameView(newGame: false)} ) {
                    Text("Continue")
                }.buttonStyle(PlainButtonStyle())
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
