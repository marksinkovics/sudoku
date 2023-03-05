import SwiftUI

struct SPicker<SelectionValue: Hashable & Identifiable & CustomStringConvertible, Content: View> : View {

    @State private var showLiist = false
    @Binding var selection: SelectionValue
    
    let label: String
    let items: [SelectionValue]
    let content: (SelectionValue) -> Content

    public init(selection: Binding<SelectionValue>, label: String, items: [SelectionValue], @ViewBuilder content: @escaping (SelectionValue) -> Content) {
        self._selection = selection
        self.label = label
        self.items = items
        self.content = content
    }
        
    var body: some View {
        Button {
            showLiist.toggle()
        } label: {
            HStack {
                Text(label)
                Spacer()
                content(selection)
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color.App.List.cellText)
            }
        }
        .navigationDestination(isPresented: $showLiist) {
            selectionView
        }
    }
    
    var selectionView: some View {
        Form {
            ForEach(items) { item in
                Button(action: {
                    self.selection = item
                }) {
                    HStack {
                        content(item)
                        Spacer()
                        if self.selection == item {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.App.List.cellText)
                                
                        }
                    }
                    .contentShape(Rectangle())
                    .foregroundColor(.primary)
                }
            }
            .listRowBackground(Color.App.List.cellBackground)
        }
        .modifier(FormBackgroundColorModifier(color: Color.App.List.background))
        .navigationBarTitle(label)
    }
}

extension SPicker where SelectionValue: Hashable & Identifiable & CustomStringConvertible, Content == Text {
    init(selection: Binding<SelectionValue>, label: String, items: [SelectionValue]) {
        self.init(selection: selection, label: label, items: items, content: {
            Text($0.description).foregroundColor(Color.gray)
        })
    }
}

struct SPicker_Previews: PreviewProvider {
    static var previews: some View {
        SPicker(selection: .constant(UserSettings.Appereance.system), label: "Appearances", items: UserSettings.Appereance.allCases)
    }
}
