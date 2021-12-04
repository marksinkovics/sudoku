import SwiftUI

public struct CheckmarkView: View {
    
    @State private var percentage: CGFloat = .zero
    var color: Color = .black
    var size: CGFloat = 60
    var width: CGFloat { size }
    var height: CGFloat { size }
    var lineSize: CGFloat = 8
    
    public var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: width / 2.5, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: lineSize, lineCap: .round, lineJoin: .round))
        .animation(.spring().speed(1).delay(0.25), value: percentage)
        .onAppear {
            percentage = 1.0
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

struct CheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        CheckmarkView()
    }
}

public struct CheckmarkToast: View {
    public var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
            CheckmarkView()
        }
        .frame(width: 200, height: 200, alignment: .center)
        .cornerRadius(15)

    }
}

