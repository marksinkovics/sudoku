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
    
    struct App {
        
        static let background = Color("background")
        
        struct Home {
            static let title = Color("title")
            static let button_background = Color("button_background")
            static let button_shadow = Color("button_shadow")
            static let button_text = Color("button_text")
            static let secondary_button_background = Color("secondary_button_background")
            static let secondary_button_shadow = Color("secondary_button_shadow")
            static let secondary_button_text = Color("secondary_button_text")
            static let cancel_button_background = Color("cancel_button_background")
            static let cancel_button_shadow = Color("cancel_button_shadow")
            static let cancel_button_text = Color("cancel_button_text")
        }
        
        struct List {
            static let background = Color("list_background")
            static let cellBackground = Color("list_cell_background")
            static let cellText = Color("list_cell_text")
        }
        
        struct Game {
            static let toolbarIcon = Color("game_toolbar_icon")
        }
    }
}

extension UIColor {
    static let sText = UIColor(named: "text_color")!
    static let sHighlighted = UIColor(named: "highlighted_color")!
    static let sSelected = UIColor(named: "selected_color")!
    static let sFixed = UIColor(named: "fixed_color")!
    static let sBackground = UIColor(named: "background_color")!
    static let sCellBackground = UIColor(named: "cell_background_color")!
    static let sError = UIColor(named: "error_color")!
    static let sSwitchColor = UIColor(named: "switch_color")!
    
    struct App {
        
        static let background = UIColor(named: "background")!

        struct Home {
            static let title = UIColor(named: "title")!
            static let button_background = UIColor(named: "button_background")!
            static let button_shadow = UIColor(named: "button_shadow")!
            static let button_text = UIColor(named: "button_text")!
            static let secondary_button_background = UIColor(named: "secondary_button_background")!
            static let secondary_button_shadow = UIColor(named: "secondary_button_shadow")!
            static let secondary_button_text = UIColor(named: "secondary_button_text")!
        }
        
        struct List {
            static let background = UIColor(named: "list_background")
            static let cellBackground = UIColor(named: "list_cell_background")
            static let cellText = UIColor(named: "list_cell_text")
        }

    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

