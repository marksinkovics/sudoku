import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sudoku: Sudoku
    
    public init(sudoku: Sudoku) {
        self.sudoku = sudoku
    }
    
    var body: some View {
        VStack {
            Text(sudoku.finished ? "Congratulation" : "Sudoku")
            Spacer()
            Board(sudoku: sudoku)
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
            Spacer()
            Numpad(sudoku: sudoku)
                .aspectRatio(9/1, contentMode: .fit)
                .padding(.leading)
                .padding(.trailing)
            Spacer()
            HStack(alignment: .center) {
                Text("Generate")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.generate() }
                    .frame(width: 80)
                Text("Solve")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.solve() }
                    .frame(width: 80)
                Text("Clear All")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.clearAll() }
                    .frame(width: 80)
                Text("Clear")
                    .font(.body)
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.clearSelected() }
                    .frame(width: 80)

            }
            Spacer()
        }.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    
    private static var sudoku: Sudoku = Sudoku()

    static var previews: some View {
        ContentView(sudoku: Sudoku())
    }
}
