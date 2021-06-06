import SwiftUI


struct ArcButton: View {
    
    let fillColor = Color.random
    let strokeColor = Color.black
    let startAngle: Angle
    let endAngle: Angle
    let height: CGFloat
    var rotationAdjustment: Angle = Angle.degrees(160)
    var text: String = "A"
    var action: () -> Void = {}
        
    var body: some View {
        GeometryReader { geometry in
            let modifiedStartAngle = startAngle - rotationAdjustment
            let modifiedEndAngle = endAngle - rotationAdjustment
            let rect = geometry.frame(in: .local)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let textRadius: CGFloat = rect.width / 2 - (height / 2)
            let textMidAngle: Angle = modifiedStartAngle + .degrees(abs(modifiedStartAngle.degrees - modifiedEndAngle.degrees) / 2)
            let textPosition = CGPoint(x: center.x + textRadius * cos(CGFloat(textMidAngle.radians)), y: center.y + textRadius * sin(CGFloat(textMidAngle.radians)))

            ZStack {
                Arc(startAngle: modifiedStartAngle, endAngle: modifiedEndAngle)
                    .fill(fillColor, strokeBorder: self.strokeColor, lineWidth: 2)
                Button(text, action: self.action)
                    .frame(width: 50, height: 50)
                    .rotationEffect(textMidAngle + .degrees(90))
                    .position(textPosition)
            }
        }
    }
    
    func action(action: @escaping () -> Void) -> Self {
        var copy = self
        copy.action = action
        return copy
    }

}

enum NumpadKey {
    case numpad(Int)
    case clear
    
    var text: String {
        switch self {
            case .clear: return "X"
            case .numpad(let value): return "\(value)"
        }
    }
}

struct NumpadRingView: View {
    static let maxRowCount = 5
    static let maxDegree: Double = 90
    static let stepDegree = maxDegree / Double(maxRowCount)
    static let height: CGFloat = 40
    static let keys: [NumpadKey] = [
        .numpad(1),
        .numpad(2),
        .numpad(3),
        .numpad(4),
        .numpad(5),
        .numpad(6),
        .numpad(7),
        .numpad(8),
        .numpad(9),
        .clear,
    ]
        
    enum Handed {
        case left
        case right
        
        var angle: Angle {
            switch self {
            case .left:
                return Angle.degrees(90)
            case .right:
                return Angle.degrees(180)
            }
        }
    }
    
    var handed: Handed = .right
    var numpadAction: (_ key: NumpadKey) -> Void = { _ in }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<Self.keys.count, id: \.self) { index in
                    let key = Self.keys[index]
                    let degreeMultiplier = index % Self.maxRowCount
                    let startAngle: Angle = .degrees(Double(degreeMultiplier) * Self.stepDegree)
                    let endAngle: Angle = .degrees((Double(degreeMultiplier) + 1) * Self.stepDegree)
                    let offset = index < Self.maxRowCount ? 0 : (Self.height * 2)
                    ArcButton(startAngle: startAngle,
                              endAngle: endAngle,
                              height: NumpadRingView.height,
                              rotationAdjustment: self.handed.angle,
                              text: key.text)
                        .action { self.numpadAction(key) }
                        .frame(width: geometry.size.width - offset, height: geometry.size.height - offset)
                }
            }
        }
    }
    
    func numpadAction(action: @escaping (_ key: NumpadKey) -> Void) -> Self {
        var copy = self
        copy.numpadAction = action
        return copy
    }

}

struct NumpadRingView_Previews: PreviewProvider {
    
    static var previews: some View {

        GeometryReader { geometry in
            
            Rectangle()
                .frame(width: 100, height: 100)
                .position(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                .background(Color.red)
            
            NumpadRingView(handed: .right)
                .position(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                .frame(width: 300, height: 300)
                .fixedSize()

            NumpadRingView(handed: .left)
                .position(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                .frame(width: 300, height: 300)
                .fixedSize()

        }

    }
}
