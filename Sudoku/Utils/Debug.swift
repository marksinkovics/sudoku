import SwiftUI

extension View {
    func print(_ value: Any) -> Self {
        Swift.print(value)
        return self
    }
}
