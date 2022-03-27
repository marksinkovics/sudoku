import SwiftUI
import UIKit

struct DebugView: View {
        
    @State var showingConfettiToast: Bool = false
    @State var showingCheckmarkToast: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.App.List.background
    }
        
    var body: some View {
        Form {
            Section(header: Text("Debug")) {
                HStack {
                    Button("Confetti") { self.showingConfettiToast = true }
                    Spacer()
                }
                .toast(isPresenting: $showingConfettiToast, toast: { ConfettiToast(title: "Congrats!!!") })
                HStack {
                    Button("Checkmark") { self.showingCheckmarkToast = true }
                    Spacer()
                }
                .toast(isPresenting: $showingCheckmarkToast, toast: { CheckmarkToast() })
            }
            .listRowBackground(Color.App.List.cellBackground)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Debug")
    }
    
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
            .preferredColorScheme(.dark)
    }
}
