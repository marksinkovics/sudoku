import SwiftUI

extension Collection {
    func count(where test:(Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

class GameController: ObservableObject {
    
    var data: BoardData
    let solver: Solver
    let generator: Generator
    var selectedItem: Item?
    var selectedRow: Int?
    var selectedColumn: Int?
    let numpadItems: [NumpadItem] = (1...9).map { NumpadItem(value: .number($0)) }
    
    var highlightRow: Bool = false {
        didSet {
            guard let row = selectedRow, let column = selectedColumn else { return }
            highlight(row: row, column: column)
        }
    }
    var highlightColumn: Bool = false
    {
       didSet {
           guard let row = selectedRow, let column = selectedColumn else { return }
           highlight(row: row, column: column)
       }
   }
    var highlightBlock: Bool = false
    {
       didSet {
           guard let row = selectedRow, let column = selectedColumn else { return }
           highlight(row: row, column: column)
       }
   }
        
    @Published var draft: Bool
    @Published var finished: Bool
    @Published var shouldResettingAlert: Bool = false
    
    init(boardData: BoardData = BoardData()) {
        
        finished = false
        draft = false
        data = boardData
        solver = Solver(data: data)
        generator = Generator(data: data, solver: solver)

        selectedItem = data.selectedItem()
        selectedRow = data.selectedRow()
        selectedColumn = data.selectedColumn()

        if let row = selectedRow, let column = selectedColumn {
            highlight(row: row, column: column)
        }

        updateNumpad()
    }
    
    func solve() {
        data.grid.enumerated().forEach { index, item in
            if !item.fixed {
                item.number = data.solution[index]
                item.error = false
            }
        }
        updateNumpad()
    }
    
    func shouldReset() {
        shouldResettingAlert = true
    }
    
    func reset() {
        data.grid.forEach { if !$0.fixed { $0.number = 0 } }
        updateNumpad()
    }
    
    func delete() {
        set(number: 0)
    }
    
    func select(row: Int, column: Int) {
        guard selectedRow != row || selectedColumn != column else {
            return
        }

        self.selectedItem?.selected = false
        self.selectedItem = data[row, column]
        self.selectedItem?.selected = true
        self.selectedRow = row
        self.selectedColumn = column
        
        highlight(row: row, column: column)
        save()
    }
    
    func highlight(row: Int, column: Int) {
        self.data.unhighlightAll()
        
        if highlightRow {
            self.data.row(at: row).forEach { $0.highlighted = true }
        }
        
        if highlightColumn {
            self.data.column(at: column).forEach { $0.highlighted = true }
        }
        
        if highlightBlock {
            self.data.block(at: row, column).forEach { $0.highlighted = true }
        }
                
        // same numbers
        self.data.grid.filter { $0.number == selectedItem!.number }.forEach {
            if $0.number > 0 {
                $0.highlighted = true;
            }
        }
    }
    
    func set(number: Int) {
        guard let selectedItem = self.selectedItem,
            let selectedRow = self.selectedRow,
            let selectedColumn = self.selectedColumn,
            !selectedItem.fixed else {
            return
        }
        
        if draft && number != 0 {
            if selectedItem.number == 0 {
                selectedItem.draftNumbers[number - 1].hidden.toggle()
            }
            return
        }
                
        selectedItem.number = number
        highlight(row: selectedRow, column: selectedColumn)
        updateNumpad()
                        
        if validate(number: selectedItem.number, atRow: selectedRow, column: selectedColumn) {
            selectedItem.error = false
            validateBoard();
        } else {
            selectedItem.error = true
        }
        
        save();
    }
    
    func validate(number: Int, atRow row: Int, column: Int) -> Bool {
        guard number != 0 else {
            return true
        }
        
        let index = row * data.rows + column;
        return data.solution[index] == data[row, column].number
    }
    
    func validateBoard() {
        self.finished = data.grid.count { $0.number == 0 } == 0
    }
    
    func updateNumpad() {
        let error = data.grid.count { !$0.error } == 0
        
        guard !error else { return }
        
        numpadItems.forEach { item in
            item.hidden = data.grid.count { item.value == .number($0.number) } == 9
        }
    }
    
    func generate(difficulty: BoardData.Difficulty) {
        generator.generate(difficulty: difficulty)
        if let indexOfFirstNonFixedItem = data.grid.firstIndex(where: { !$0.fixed }) {
            let row = indexOfFirstNonFixedItem / data.columns
            let column = indexOfFirstNonFixedItem % data.columns
            select(row: row, column: column)
        }
        updateNumpad()
        save()
    }
    
    static var lastSavedGame: BoardData? = nil

    func save() {
        let encoder = JSONEncoder()
        do {
            GameController.lastSavedGame = data
            let encodedData = try encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: "saved")
        } catch {
            debugPrint(error)
        }
    }
        
    static func loadSavedGame(completion: @escaping (BoardData?) -> Void) {
        guard let encodedData = UserDefaults.standard.data(forKey: "saved") else {
            completion(nil)
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(BoardData.self, from: encodedData)
                GameController.lastSavedGame = result
                completion(result)
            } catch {
                completion(nil)
            }
        }
    }
    
    static func cleanSaved() {
        GameController.lastSavedGame = nil
        UserDefaults.standard.removeObject(forKey: "saved")
    }
}
