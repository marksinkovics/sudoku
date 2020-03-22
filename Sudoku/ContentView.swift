import SwiftUI

struct ContentView: View {
    
    private let sudoku: Sudoku
    
    public init(sudoku: Sudoku) {
        self.sudoku = sudoku
    }
    
    var body: some View {
        VStack {
            Spacer()
            Board()
                .environmentObject(sudoku.data)
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
            Spacer()
            Numpad()
                .environmentObject(sudoku.data)
                .aspectRatio(9/1, contentMode: .fit)
                .padding(.leading)
                .padding(.trailing)
            Spacer()
            HStack {
                Text("Generate")
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.generate() }
                Text("Solve")
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.solve() }
                Text("Clear")
                    .foregroundColor(Color(.label))
                    .onTapGesture { self.sudoku.clear() }
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
