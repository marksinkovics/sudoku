import SwiftUI

//TODO: delete!!!

struct LazyView<Content: View>: View {
    let builder: () -> Content
    init(@ViewBuilder builder: @escaping () -> Content) {
        self.builder = builder
    }
    var body: some View {
        builder()
    }
}

struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView {
            Text("Sample")
        }
    }
}
