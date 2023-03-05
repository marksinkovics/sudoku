import SwiftUI

struct ToolBarItem: View {
    let text: String
    let systemName: String

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color.App.Game.toolbarText)
        }
        .frame(width: 80)
    }
}

struct ToolBarItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ToolBarItem(text: "Draft", systemName: "square.and.pencil")
                .foregroundStyle(.yellow, Color.App.Game.toolbarRed)
            ToolBarItem(text: "Final", systemName: "pencil.line")
                .foregroundStyle(.yellow, Color.App.Game.toolbarRed)
            ToolBarItem(text: "Undo", systemName: "eraser.line.dashed")
                .foregroundStyle(.cyan, .yellow)
            ToolBarItem(text: "Reset all", systemName: "trash")
                .foregroundStyle(Color.App.Game.toolbarTrash)
            ToolBarItem(text: "Solve", systemName: "wand.and.stars")
                .foregroundStyle(Color.App.Game.toolbarWand, .purple)

        }
    }
}
