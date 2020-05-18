import SwiftUI

struct LevelView: View {
    
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        ZStack {
            Color.sBackground.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 60) {
                NavigationLink(destination: LazyView { GameView(state: .new(difficulty: .easy), shouldPopToRootView: self.$shouldPopToRootView)}) {
                    MenuItemView("Easy")
                }.isDetailLink(false)
                NavigationLink(destination: LazyView { GameView(state: .new(difficulty: .hard), shouldPopToRootView: self.$shouldPopToRootView)}) {
                    MenuItemView("Hard")
                }.isDetailLink(false)
                NavigationLink(destination: LazyView { GameView(state: .new(difficulty: .expert), shouldPopToRootView: self.$shouldPopToRootView)}) {
                    MenuItemView("Expert")
                }.isDetailLink(false)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(label: "Home"){
            self.shouldPopToRootView = false
        })
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(shouldPopToRootView: .constant(true))
            .environment(\.colorScheme, .dark)
    }
}
