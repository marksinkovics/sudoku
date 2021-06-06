import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    let height: CGFloat = 40

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius1: CGFloat = rect.width / 2
        let radius2: CGFloat = rect.width / 2 - height
        var path = Path()
        path.addArc(center: center, radius: radius1, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: radius2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.addLine(to: CGPoint(x: center.x + radius1 * cos(CGFloat(startAngle.radians)), y: center.y + radius1 * sin(CGFloat(startAngle.radians))))
        path.closeSubpath()
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    
    static let startAngle: Angle = .degrees(0)
    static let endAngle: Angle = .degrees(22.5)
    
    static var previews: some View {
        Arc(startAngle: startAngle, endAngle: endAngle)
            .fill(Color.red, strokeBorder: Color.blue, lineWidth: 2)
            .frame(width: 250, height: 250)
    }
}
