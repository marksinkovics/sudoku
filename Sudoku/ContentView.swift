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


struct ContentView: View {
    
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        HomeView()
            .accentColor(Color.sText)
            .userInterfaceStyle(userSettings.suggestedUserInterfaceStyle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
