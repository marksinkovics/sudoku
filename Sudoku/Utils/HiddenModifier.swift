import SwiftUI

fileprivate struct HiddenModifier: ViewModifier {
    let isHidden: Bool

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}

extension View {
    func isHidden(_ hidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: hidden))
    }
}
