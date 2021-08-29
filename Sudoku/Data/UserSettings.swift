import Foundation
import Combine
import SwiftUI

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

class UserSettings: ObservableObject {
    
    enum Appereance: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
        var id: Int { rawValue }
        
        case system
        case light
        case dark
        
        var description: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }
    
    enum NumpadType: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
        var id: Int { rawValue }
        
        case row
        case arc
        case pencil
        
        var description: String {
            switch self {
            case .row: return "Row"
            case .arc: return "Arc"
            case .pencil: return "Pencil"
            }
        }
    }

    
    enum Keys: String {
        case highlightRow = "highlight.row"
        case highlightColumn = "highlight.column"
        case highlightBlock = "highlight.block"
        case appereance = "appereance"
        case numpadType = "numpad.type"
    }
    
    @Published var higlightRow: Bool {
        didSet {
            UserDefaults.standard.set(higlightRow, forKey: Keys.highlightRow.rawValue)
        }
    }
    @Published var highlightColumn: Bool {
       didSet {
           UserDefaults.standard.set(highlightColumn, forKey: Keys.highlightColumn.rawValue)
       }
   }
    
    @Published var highlightBlock: Bool{
        didSet {
            UserDefaults.standard.set(highlightBlock, forKey: Keys.highlightBlock.rawValue)
        }
    }
    
    @Published var appereance: Appereance {
        didSet {
            UserDefaults.standard.set(appereance.rawValue, forKey: Keys.appereance.rawValue)
        }
    }

    @Published var numpadType: NumpadType {
        didSet {
            UserDefaults.standard.set(numpadType.rawValue, forKey: Keys.numpadType.rawValue)
        }
    }
    
    init() {
        self.higlightRow = UserDefaults.standard.bool(forKey: Keys.highlightRow.rawValue)
        self.highlightColumn = UserDefaults.standard.bool(forKey: Keys.highlightColumn.rawValue)
        self.highlightBlock = UserDefaults.standard.bool(forKey: Keys.highlightBlock.rawValue)
        self.appereance = Appereance(rawValue: UserDefaults.standard.integer(forKey: Keys.appereance.rawValue)) ?? .system
        self.numpadType = NumpadType(rawValue: UserDefaults.standard.integer(forKey: Keys.numpadType.rawValue)) ?? .row
    }
    
    //
    
    var suggestedUserInterfaceStyle: UIUserInterfaceStyle {
        if appereance == .dark {
            return .dark
        }

        if appereance == .light {
            return .light
        }

        return .unspecified
    }

}
