import SwiftUI
 
struct ArcNumpadView: UIViewRepresentable {
    
    var action: (ArcNumpadKey) -> Void = { _ in }
    let direction: ArcNumpadDirection
    
    class Coordinator: NSObject, ArcNumpadUIViewDelegate {
        var parent: ArcNumpadView

        init(_ parent: ArcNumpadView) {
            self.parent = parent
        }
        
        func tapped(key: ArcNumpadKey) -> Void {
            self.parent.action(key)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ArcNumpadUIView {
        let numpadView = ArcNumpadUIView()
        numpadView.direction = context.coordinator.parent.direction
        numpadView.delegate = context.coordinator
        return numpadView
    }

    func updateUIView(_ uiView: ArcNumpadUIView, context: Context) {
        debugPrint("Update UIVIEW")
    }
    
    func action(_ action: @escaping (ArcNumpadKey) -> Void) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}

struct HoverableView_Previews: PreviewProvider {
    static var previews: some View {
        ArcNumpadView(direction: .right)
            .background(Color.clear)
            .frame(width: 300, height: 300)
    }
}
