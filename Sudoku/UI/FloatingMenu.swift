import SwiftUI

struct FloatingMenu: View {
    
    let frame: CGRect
    
    var dismiss: () -> Void = {}
    var selected: (_ key: NumpadKey) -> Void = { _ in }
    
    var body: some View {
        
        let handed: NumpadRingView.Handed = frame.minX - 100 < 0 ? .left : .right
        let offsetX: CGFloat = handed == .right ? 30 : -30;
        let offsetY: CGFloat = handed == .right ? -100 : -100;
        
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color.black.opacity(0.01))
                    .onTapGesture(perform: self.dismiss)
                NumpadRingView(handed: handed)
                    .numpadAction { key in
                        self.selected(key)
                        self.dismiss()
                    }
                    .frame(width: 300, height: 300)
                    .position(x: frame.midX + offsetX, y: frame.midY + offsetY)
            }
        }
    }

    func dismiss(action: @escaping () -> Void) -> Self {
        var copy = self
        copy.dismiss = action
        return copy
    }

    func selected(action: @escaping (_ key: NumpadKey) -> Void) -> Self {
        var copy = self
        copy.selected = action
        return copy
    }

}
    

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu(frame: .zero)
    }
}
