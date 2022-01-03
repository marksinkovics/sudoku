import SwiftUI

struct NavigationLinkModifier<Value, Destination: View>: ViewModifier {
    let value: Binding<Value?>
    let destination: (Value) -> Destination

    @ViewBuilder
    private func makeDestination() -> some View {
        if let value = self.value.wrappedValue {
            self.destination(value)
        } else {
            EmptyView()
        }
    }
    
    private func makeBinding() -> Binding<Bool> {
        Binding(
            get: { self.value.wrappedValue != nil },
            set: { newValue in if !newValue { self.value.wrappedValue = nil } }
        )
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(destination: makeDestination(), isActive: makeBinding(), label: EmptyView.init)
            )
    }
}

extension View {
    @ViewBuilder
    func navigate<Value, Destination: View>(using value: Binding<Value?>, @ViewBuilder destination:  @escaping (Value) -> Destination) -> some View {
        modifier(NavigationLinkModifier(value: value, destination: destination))
    }
}

