import SwiftUI
import UIKit

struct SettingsView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
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
                Toggle(isOn: $userSettings.highlightNeighborhood) { Text("Neightborhood") }
            }
            Section(header: Text("Appearance")) {
                Picker(selection: $userSettings.appereance, label: Text("Appearances")) {
                    ForEach(UserSettings.Appereance.allCases, id: \.self) {
                        Text($0.description).foregroundColor(Color.sText)
                    }
                }
            }
            Section(header: Text("About")) {
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
        .foregroundColor(Color.sText)
   }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        .environment(\.colorScheme, .dark)
    }
}
