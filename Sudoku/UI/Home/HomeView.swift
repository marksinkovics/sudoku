import SwiftUI

struct HomeView: View {
    var body: some View {
        MenuView()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
