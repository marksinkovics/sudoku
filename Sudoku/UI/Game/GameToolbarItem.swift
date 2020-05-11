import SwiftUI

struct GameToolbarItem: View {
    let label: String
    let image: Image?
    let action: () -> Void
    
    init(label: String, image: Image? = nil, action: (() -> Void)? = nil) {
        self.label = label
        self.image = image
        self.action = action ?? {}
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                if image != nil {
                    image!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .accentColor(Color.sText)
                }
                Text(label)
                    .font(Font.body.weight(.semibold))
                    .foregroundColor(Color.sText)
            }
            .frame(width: 80, height: 60, alignment: .center)
            .padding(.vertical)
        }
    }
    
    func onAction(_ action: @escaping () -> Void) -> GameToolbarItem {
        return GameToolbarItem(label: label, image: image, action: action)
    }
    
    func image(_ image: Image) -> GameToolbarItem {
        return GameToolbarItem(label: label, image: image, action: action)
    }
    
    func image(name: String) -> GameToolbarItem {
        let image = Image(name)
        return GameToolbarItem(label: label, image: image, action: action)
    }

    func image(systemName: String) -> GameToolbarItem {
        let image = Image(systemName: systemName)
        return GameToolbarItem(label: label, image: image, action: action)
    }
}

struct GameToolItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameToolbarItem(label: "Edit", image: Image(systemName: "pencil")) {}
                .previewLayout(.sizeThatFits)
            GameToolbarItem(label: "Edit")
                .image(Image(systemName: "gobackward"))
                .previewLayout(.sizeThatFits)
        }
        
    }
}
