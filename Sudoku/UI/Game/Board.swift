import SwiftUI

struct Board: View {

    @EnvironmentObject var history: History
    @EnvironmentObject var controller: GameController

    func shouldAddSpacer(value: Int) -> Bool {
        return (value + 1) % 3 == 0
    }

    var body: some View {
        GeometryReader { geometry in
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<9) { row in
                    GridRow {
                        ForEach(0..<9) { column in
                            let item = self.controller.data[row, column]
                            BoardCell(item: item, row: row, column: column) {
                                self.controller.select(row: row, column: column)
                            }
                            if (shouldAddSpacer(value: column))
                            {
                                Spacer(minLength: 2)
                            }
                        }
                    }

                    if (shouldAddSpacer(value: row))
                    {
                        Spacer(minLength: 2)
                    }
                }
            }
        }
        .scaledToFill()
    }
     
    func hightlightRow(_ value: Bool) -> Self {
        self.controller.highlightRow = value
        return self
    }
    
    func hightlightColumn(_ value: Bool) -> Self {
        self.controller.highlightColumn = value
        return self
    }
    
    func hightlightBlock(_ value: Bool) -> Self {
        self.controller.highlightBlock = value
        return self
    }
}

struct Board_Previews: PreviewProvider {
    
    private static var controller: GameController = GameController()

    static var previews: some View {
        Board()
            .environmentObject(controller)
    }
}
