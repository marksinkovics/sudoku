import SwiftUI
import UIKit

struct DebugView: View {
        
    @State var showingConfettiToast: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.App.List.background
    }
        
    var body: some View {
        Form {
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
