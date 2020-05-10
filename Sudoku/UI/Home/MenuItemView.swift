import SwiftUI

struct MenuItemView: View {
    
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
        .foregroundColor(Color("text_color"))
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
                .background(Color("background_color"))
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
                .background(Color("background_color"))
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
            }
        }        
    }
}
