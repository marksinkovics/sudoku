import Foundation
import CoreGraphics

struct Angle {
    var value: CGFloat //in radians
    init(degrees: CGFloat) {
        value = degrees * .pi / 180.0
    }
    
    init(radians: CGFloat) {
        self.value = radians
    }
    
    static let zero = Angle(radians: .zero)
    static let pi = Angle(radians: .pi)

    var degrees: CGFloat {
        return value * 180.0 / .pi
    }

    var radians: CGFloat {
        return value
    }

    static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.value - rhs.value)
    }

    static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.value + rhs.value)
    }
    
    static func + (lhs: Angle, rhs: CGFloat) -> Angle {
        return Angle(radians: lhs.value + rhs)
    }
    
    static func * (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.value * rhs.value)
    }

    static func / (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.value / rhs.value)
    }
    
    //
    // Unary
    //
    
    static prefix func - (angle: Angle) -> Angle {
        return Angle(radians: -angle.radians)
    }
    
    static prefix func + (angle: Angle) -> Angle {
        return Angle(radians: +angle.radians)
    }

    //
    // Different types
    //
    
    static func * (lhs: Angle, rhs: Int) -> Angle {
        return Angle(radians: lhs.value * CGFloat(rhs))
    }
    
    static func * (lhs: Angle, rhs: CGFloat) -> Angle {
        return Angle(radians: rhs * lhs.value)
    }

    static func / (lhs: Angle, rhs: Int) -> Angle {
        return Angle(radians: lhs.value / CGFloat(rhs))
    }
    
}
