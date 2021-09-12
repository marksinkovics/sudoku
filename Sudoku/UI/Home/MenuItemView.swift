import SwiftUI

struct MenuItemViewButtonStyle: ButtonStyle {
    
    let style: MenuItemView.Style
    let enabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .foregroundColor(enabled ? style.button_text : Color.sFixed)
            .font(style.font)
            .background(
                VStack(spacing: 0) {
                    style.button_background
                    style.button_shadow.frame(height: 10)
                }
                .frame(width: style.width, height: style.height)
                .cornerRadius(5)
            )
            .scaleEffect(configuration.isPressed && enabled ? 0.9 : 1.0)
    }
}

struct MenuItemView: View {
    
    enum Style {
        case primary
        case secondary
        
        var button_background: Color {
            switch self {
            case .primary: return Color.App.Home.button_background
            case .secondary: return Color.App.Home.secondary_button_background
            }
        }
        
        var button_shadow: Color {
            switch self {
            case .primary: return Color.App.Home.button_shadow
            case .secondary: return Color.App.Home.secondary_button_shadow
            }
        }

        var button_text: Color {
            switch self {
            case .primary: return Color.App.Home.button_text
            case .secondary: return Color.App.Home.secondary_button_text
            }
        }

        var height: CGFloat {
            switch self {
            case .primary: return 70
            case .secondary: return 60
            }
        }
        
        var width: CGFloat {
            switch self {
            case .primary: return 300
            case .secondary: return 250
            }
        }
        
        var font: Font {
            switch self {
            case .primary: return .system(size: 30, weight: .semibold, design: .rounded)
            case .secondary: return .system(size: 25, weight: .semibold, design: .rounded)
            }
        }
    }
    
    let title: String
    @Binding var enabled: Bool
    let action: () -> Void
    let style: Style

    init(_ title: String, enabled: Binding<Bool> = .constant(true), style: Style = .primary, action: (() -> Void)? = nil) {
        self.title = title
        self._enabled = enabled
        self.action = action ?? {}
        self.style = style
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .offset(CGSize(width: 0, height: -5))
        }
        .disabled(!enabled)
        .buttonStyle(MenuItemViewButtonStyle(style: style, enabled: enabled))
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
