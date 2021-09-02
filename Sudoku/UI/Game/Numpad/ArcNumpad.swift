import SwiftUI

struct ArcNumpad: View {
    
    let frame: CGRect
    
    var dismiss: () -> Void = {}
    var selected: (_ key: ArcNumpadKey) -> Void = { _ in }
    
    var body: some View {
        let size: CGFloat = max(250, frame.height * 5)
        let direction: ArcNumpadDirection = frame.minX - (size / 2) < 0 ? .left : .right

        ZStack {
            Rectangle()
                .foregroundColor(Color.black.opacity(0.01))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: self.dismiss)
            ArcNumpadView(direction: direction)
                .action(selected)
                .background(Color.red.opacity(0.5))
                .frame(width: size, height: size)
                .position(x: frame.midX , y: frame.midY + 4)
        }
        .edgesIgnoringSafeArea(.all)

    }

    func dismiss(action: @escaping () -> Void) -> Self {
        var copy = self
        copy.dismiss = action
        return copy
    }

    func selected(action: @escaping (_ key: ArcNumpadKey) -> Void) -> Self {
        var copy = self
        copy.selected = action
        return copy
    }

}
    

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        ArcNumpad(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            .dismiss {
                debugPrint("dismiss")
            }
            .selected { key in
                if case .numpad(let value) = key {
                    debugPrint("value: \(value) is pressed")
                } else {
                    debugPrint("delete is pressed")
                }
            }
    }
}
