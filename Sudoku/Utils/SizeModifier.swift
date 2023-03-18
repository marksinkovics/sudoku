import SwiftUI

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear
                .anchorPreference(key: SizePreferenceKey.self, value: .bounds) { anchor in geometry[anchor].size.width }
        }
    }

    func body(content: Content) -> some View {
        content.overlay(sizeView)
    }
}

