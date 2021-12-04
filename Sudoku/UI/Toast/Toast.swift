import SwiftUI

public struct Toast: View {
    public var body: some View {
        Color.yellow
            .frame(width: 100, height: 100, alignment: .center)
            .cornerRadius(10)
    }
}

public class ToastViewHostingController<Content: View>: UIHostingController<Content> {
    override init(rootView: Content) {
        super.init(rootView: rootView)
        commonInit()
    }
    
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }
}

public struct ToastContainer<ToastView: View>: View {

    @Binding var isPresenting: Bool
    public var toastViewBuilder: () -> ToastView
    
    public var body: some View {
        ZStack() {
            Color.black
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            toastViewBuilder()
        }
        .onTapGesture {
            withAnimation(Animation.spring()) {
                isPresenting = false
            }
        }
    }
}

extension UIApplication {
    
}

public struct ToastModifier<ToastView: View>: ViewModifier {

    @EnvironmentObject private var appData: AppData
    @Binding var isPresenting: Bool
    var duration: Double
    var toast: () -> ToastView
    var screen: CGRect {
        UIScreen.main.bounds
    }
    
    @State private var keyWindow: UIWindow?
    
    private func toastTapAction() {
        withAnimation(Animation.spring()) {
            isPresenting = false
        }
    }
    
    private func rootViewController() -> UIViewController? {
        let keyWindow: UIWindow? = appData.window
        var rootViewController = keyWindow?.rootViewController
        while true {
            if let presented = rootViewController?.presentedViewController {
                rootViewController = presented
            } else if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.visibleViewController
            } else if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            } else {
                break
            }
        }
        return rootViewController
    }

    private func present() {
        let rootViewController = rootViewController()
        let isToastAlreadyPresented = rootViewController is ToastViewHostingController<ToastContainer<ToastView>>
        
        if isPresenting {
            if !isToastAlreadyPresented {
                let toastViewController = ToastViewHostingController(rootView: ToastContainer(isPresenting: $isPresenting, toastViewBuilder: toast))
                rootViewController?.present(toastViewController, animated: true)
                
                if duration > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isPresenting = false
                    }
                }
            }
        } else {
            if isToastAlreadyPresented {
                rootViewController?.dismiss(animated: true, completion: nil)
            }
            keyWindow = nil
        }
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        content
            .onChange(of: isPresenting) { value in
                present()
            }
    }
}

public extension View {
    func toast<Content: View>(isPresenting: Binding<Bool>, duration: Double = 0, toast: @escaping () -> Content) -> some View {
        modifier(ToastModifier(isPresenting: isPresenting, duration: duration, toast: toast))
    }
}
