import SwiftUI

extension View {
    func print(_ value: Any) -> Self {
        Swift.print(value)
        return self
    }
}

extension UIColor {
    static var randomColor: UIColor {
        let hue = CGFloat(Double(arc4random() % 256) / 256.0) // 0.0 to 1.0
        let saturation = CGFloat(Double(arc4random() % 128) / 266.0 + 0.5) // 0.5 to 1.0, away from white
        let brightness = CGFloat(Double(arc4random() % 128) / 256.0 + 0.5) // 0.5 to 1.0, away from black
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
