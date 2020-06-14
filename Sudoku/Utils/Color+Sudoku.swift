import SwiftUI

extension Color {
    static let sText = Color("text_color")
    static let sHighlighted = Color("highlighted_color")
    static let sSelected = Color("selected_color")
    static let sFixed = Color("fixed_color")
    static let sBackground = Color("background_color")
    static let sCellBackground = Color("cell_background_color")
    static let sError = Color("error_color")
    static let sSwitchColor = Color("switch_color")
}

extension UIColor {
    static let sText = UIColor(named: "text_color") ?? .white
    static let sHighlighted = UIColor(named: "highlighted_color") ?? .white
    static let sSelected = UIColor(named: "selected_color") ?? .white
    static let sFixed = UIColor(named: "fixed_color") ?? .white
    static let sBackground = UIColor(named: "background_color") ?? .white
    static let sCellBackground = UIColor(named: "cell_background_color") ?? .white
    static let sError = UIColor(named: "error_color") ?? .white
    static let sSwitchColor = UIColor(named: "switch_color") ?? .white
}
