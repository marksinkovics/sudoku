import SwiftUI

struct DraftCell: View {

    @ObservedObject var item: DraftItem

    var body: some View {
        GeometryReader { gridGeometry in
            Text(self.item.text)
                .font(.system(size: 12))
                .foregroundColor(Color.sFixed)
                .frame(width: gridGeometry.size.width, height: gridGeometry.size.height)
                .isHidden(self.item.hidden)
        }
    }
}

struct DraftCell_Previews: PreviewProvider {
    static var draftItem = DraftItem(number: 2, hidden: false)
    static var previews: some View {
        DraftCell(item: draftItem)
    }
}
