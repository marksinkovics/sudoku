import SwiftUI

struct MenuItemView: View {
    
    let title: String
    let enabled: Bool

    init(_ title: String, enabled: Bool = true) {
        self.title = title
        self.enabled = enabled
    }
    
    var body: some View {
        Text(title)
            .foregroundColor(self.enabled ? Color.sText : Color.sFixed)
            .font(Font.system(size: 30))
            .fontWeight(.semibold)
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                VStack(alignment: .center, spacing: 30) {
                    MenuItemView("New game")
                    MenuItemView("Continue")
                    MenuItemView("Settings")
                }
                .padding()
                .background(Color.sBackground)
                .environment(\.colorScheme, .dark)
                .previewLayout(.sizeThatFits)
            }
            Group {
                VStack(alignment: .center, spacing: 30) {
                    MenuItemView("New game")
                    MenuItemView("Continue")
                    MenuItemView("Settings")
                }
                .padding()
                .background(Color.sBackground)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
            }
        }        
    }
}
