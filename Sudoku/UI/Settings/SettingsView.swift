import SwiftUI
import UIKit

struct SettingsView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    let projectPageURL = URL(string: "https://marksinkovics.com/projects/sudoku")!
    let privacyPolicyURL = URL(string: "https://marksinkovics.com/projects/sudoku/privacy-policy")!
    
    @State private var showDeleteSuccessToast = false
    
    #if DEBUG
    @State var showingConfettiToast: Bool = false
    #endif
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.App.List.background
    }
        
    var body: some View {
        Form {
            Section(header: Text("Highlight")) {
                Toggle(isOn: $userSettings.higlightRow) { Text("Row") }
                    .toggleStyle(SwitchToggleStyle(tint: Color.App.Home.secondary_button_background))
                Toggle(isOn: $userSettings.highlightColumn) { Text("Column") }
                    .toggleStyle(SwitchToggleStyle(tint: Color.App.Home.secondary_button_background))
                Toggle(isOn: $userSettings.highlightBlock) { Text("Block") }
                    .toggleStyle(SwitchToggleStyle(tint: Color.App.Home.secondary_button_background))
            }
            .listRowBackground(Color.App.List.cellBackground)
            
            Section(header: Text("Appearance")) {
                SPicker(selection: $userSettings.appereance, label: "Appearances", items: UserSettings.Appereance.allCases) {
                    Text($0.description).foregroundColor(Color.App.List.cellText)
                }
            }
            .listRowBackground(Color.App.List.cellBackground)

            Section(header: Text("Privacy")) {
                HStack {
                    Button("Privacy Policy") { UIApplication.shared.open(self.privacyPolicyURL) }
                        .foregroundColor(Color.App.List.cellText)
                    Spacer()
                }
            }
            .listRowBackground(Color.App.List.cellBackground)
            
            Section(header: Text("Game")) {
                HStack {
                    Button("Erase saved game") {
                        GameController.cleanSaved()
                        showDeleteSuccessToast = true
                    }
                    .foregroundColor(Color.App.List.cellText)
                    Spacer()
                }
            }
            .listRowBackground(Color.App.List.cellBackground)

                
            Section(header: Text("About")) {
                HStack {
                    Button("Visit the project's website") { UIApplication.shared.open(self.projectPageURL) }
                        .foregroundColor(Color.App.List.cellText)
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
            .listRowBackground(Color.App.List.cellBackground)
            
            #if DEBUG
            Section(header: Text("Debug")) {
                HStack {
                    Button("Confetti") {
                        self.showingConfettiToast = true
                    }
                    Spacer()
                }
                .toast(isPresenting: $showingConfettiToast, toast: { ConfettiToast(title: "Congrats!!!") })
            }
            .listRowBackground(Color.App.List.cellBackground)
            #endif
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Settings")
        .toast(isPresenting: $showDeleteSuccessToast, duration: 1, toast: { CheckmarkToast() })
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
