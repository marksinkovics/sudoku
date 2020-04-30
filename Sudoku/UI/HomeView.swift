import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
             VStack(alignment: .center, spacing: 30) {
                NavigationLink(destination: GameView(controller: GameController())) {
                    Text("New game")
                }.buttonStyle(PlainButtonStyle())
                NavigationLink(destination: GameView(controller: GameController())) {
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
