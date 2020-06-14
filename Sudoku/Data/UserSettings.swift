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
    
    enum Keys: String {
        case highlightRow = "highlight.row"
        case highlightColumn = "highlight.column"
        case highlightNeighborhood = "highlight.neighborhood"
        case appereance = "appereance"
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
    
    @Published var highlightNeighborhood: Bool{
        didSet {
            UserDefaults.standard.set(highlightNeighborhood, forKey: Keys.highlightNeighborhood.rawValue)
        }
    }
    
    @Published var appereance: Appereance {
        didSet {
            UserDefaults.standard.set(appereance.rawValue, forKey: Keys.appereance.rawValue)
        }
    }
        
    init() {
        self.higlightRow = UserDefaults.standard.bool(forKey: Keys.highlightRow.rawValue)
        self.highlightColumn = UserDefaults.standard.bool(forKey: Keys.highlightColumn.rawValue)
        self.highlightNeighborhood = UserDefaults.standard.bool(forKey: Keys.highlightNeighborhood.rawValue)
        self.appereance = Appereance(rawValue: UserDefaults.standard.integer(forKey: Keys.appereance.rawValue)) ?? .system
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
