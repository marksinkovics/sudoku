import SwiftUI
import UIKit

extension View {
    
    func userInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        keyWindow?.overrideUserInterfaceStyle = style
        keyWindow?.setNeedsDisplay()
        
        return self
    }
}

struct NavigationBarColor: ViewModifier {

  init(backgroundColor: UIColor, tintColor: UIColor) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.shadowColor = .clear
    coloredAppearance.shadowImage = UIImage()

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
  }

  func body(content: Content) -> some View {
    content
  }
}

struct ToolBarColor: ViewModifier {
    init(backgroundColor: UIColor, tintColor: UIColor) {
        UIToolbar.appearance().barTintColor = backgroundColor
        UIToolbar.appearance().backgroundColor = backgroundColor
        UIToolbar.appearance().setShadowImage(nil, forToolbarPosition: .any)
    }
    
    func body(content: Content) -> some View {
      content
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
    
    func toolBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(ToolBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {

    @StateObject var router = Router()
    @StateObject var gameController = GameController()

    @EnvironmentObject var userSettings: UserSettings

    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.sText
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .accentColor(Color.sText)
                .userInterfaceStyle(userSettings.suggestedUserInterfaceStyle)

        }
        .background(Color.App.background)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarColor(backgroundColor: .sBackground, tintColor: .sText)
        .toolBarColor(backgroundColor: .sBackground, tintColor: .sText)
        .environmentObject(router)
        .environmentObject(gameController)
        .accentColor(.sText)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
