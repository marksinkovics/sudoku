import SwiftUI

struct GridStack<Content: View>: View {

    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    let spacing: CGFloat?
            
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: self.spacing) {
                ForEach(0 ..< self.rows, id: \.self) { row in
                    HStack(spacing: self.spacing) {
                        ForEach(0 ..< self.columns, id: \.self) { column in
                            self.content(row, column)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
        self.spacing = spacing ?? 0
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: 9, columns: 9) { row, col in
            GeometryReader { geometry in
                Text("\(row)/\(col)")
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
                    .background(Color.green)
            }
        }.scaledToFit()
    }
}
