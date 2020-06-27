import SwiftUI

struct MenuItemViewButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct MenuItemView: View {
    
    let title: String
    @Binding var enabled: Bool
    let action: () -> Void

    init(_ title: String, enabled: Binding<Bool> = .constant(true), action: (() -> Void)? = nil) {
        self.title = title
        self._enabled = enabled
        self.action = action ?? {}
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(self.enabled ? Color.sText : Color.sFixed)
                .font(Font.system(size: 30))
                .fontWeight(.semibold)
        }
        .disabled(!enabled)
        .buttonStyle(MenuItemViewButtonStyle())
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
