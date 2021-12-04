import SwiftUI

final class AppData: ObservableObject {
    weak var window: UIWindow?
    init(window: UIWindow? = nil) {
        self.window = window
    }
}
