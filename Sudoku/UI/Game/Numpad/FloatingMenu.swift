import SwiftUI

struct FloatingMenu: View {
    
    let frame: CGRect
    
    var dismiss: () -> Void = {}
    var selected: (_ key: ArcNumpadKey) -> Void = { _ in }
    
    var body: some View {
        
        let size = frame.height * 4
        let direction: ArcNumpadDirection = frame.minX - (size / 2) < 0 ? .left : .right
        let offsetX: CGFloat = 0
        // numpad size - cell size / 2 + cell border * 2
        let offsetY: CGFloat = -(size / 2 - (frame.height / 2))
        

        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color.black.opacity(0.01))
                    .onTapGesture(perform: self.dismiss)
                ArcNumpadView(direction: direction)
                    .action(selected)
                    .frame(width: frame.height * 4, height: frame.height * 4)
                    .position(x: frame.midX + offsetX, y: frame.midY + offsetY)
            }
        }
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
        FloatingMenu(frame: .zero)
    }
}
