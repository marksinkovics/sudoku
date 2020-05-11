import SwiftUI

struct BackButton: View {
    
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                    .font(Font.callout.weight(.semibold))
                    .accentColor(Color.sText)
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.sText)
            }
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(label: "Back") {}
            .previewLayout(.sizeThatFits)
    }
}
