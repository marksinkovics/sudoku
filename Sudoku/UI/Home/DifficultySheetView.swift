import SwiftUI

struct DifficultySheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var items: [MenuItemView]

    var body: some View {
        VStack {
            Spacer()
            Text("Select the difficulty")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(Color.App.Home.title)
                .padding(.bottom, 30)
            ForEach(items,id: \.id) { item in
                item
                    .padding(30)
            }
            Spacer()
            MenuItemView("Dismiss", style: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.App.background)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DifficultySheetView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultySheetView(items: [
            MenuItemView("Easy"),
            MenuItemView("Medium"),
            MenuItemView("Hard"),
            MenuItemView("Expert")
        ])
    }
}
