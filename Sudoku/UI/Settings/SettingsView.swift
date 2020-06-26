import SwiftUI
import UIKit

struct SettingsView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    let projectPageURL = URL(string: "https://marksinkovics.com/projects/sudoku")!
    let privacyPolicyURL = URL(string: "https://marksinkovics.com/projects/sudoku/privacy-policy")!
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.sBackground
        UITableViewCell.appearance().backgroundColor = UIColor.sCellBackground
        UISwitch.appearance().onTintColor = UIColor.sSwitchColor
    }
        
    var body: some View {
        Form {
            Section(header: Text("Highlights")) {
                Toggle(isOn: $userSettings.higlightRow) { Text("Row") }
                Toggle(isOn: $userSettings.highlightColumn) { Text("Column") }
                Toggle(isOn: $userSettings.highlightNeighborhood) { Text("Neighborhood") }
            }
            Section(header: Text("Appearance")) {
                Picker(selection: $userSettings.appereance, label: Text("Appearances")) {
                    ForEach(UserSettings.Appereance.allCases, id: \.self) {
                        Text($0.description).foregroundColor(Color.sText)
                    }
                }
            }
            Section(header: Text("Privacy")) {
                HStack {
                    Button("Privacy Policy") { UIApplication.shared.open(self.privacyPolicyURL) }
                    Spacer()
                }
            }
            Section(header: Text("About")) {
                HStack {
                    Button("Visit the project page") { UIApplication.shared.open(self.projectPageURL) }
                    Spacer()
                }
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.releaseVersionNumber)
                }
                HStack {
                    Text("Build")
                    Spacer()
                    Text(Bundle.main.buildVersionNumber)
                }
            }
        }
        .background(Color.green)
        .listStyle(GroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let userSettings = UserSettings()
    
    static var previews: some View {
        SettingsView()
        .environmentObject(userSettings)
        .preferredColorScheme(.dark)
    }
}
