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

    enum Keys: String {
        case highlightRow = "highlight.row"
        case highlightColumn = "highlight.column"
        case highlightBlock = "highlight.block"
        case appereance = "appereance"
        case numpadType = "numpad.type"
    }

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

        var description: String {
            switch self {
            case .row: return "Row"
            }
        }
    }

    @AppStorage(UserSettings.Keys.appereance.rawValue) var appereance: Appereance =  .system
    @AppStorage(UserSettings.Keys.numpadType.rawValue) var numpadType: NumpadType =  .row

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
