import SwiftUI

extension Collection {
    func count(where test:(Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

enum GameDifficulty: CustomStringConvertible, Equatable {
    case easy
    case hard
    case expert
    
    var description: String {
        switch self {
        case .easy: return "Easy"
        case .hard: return "Hard"
        case .expert: return "Expert"
        }
    }
        
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.easy, .easy):
            return true
        case (.hard, .hard):
            return true
        case (.expert, .expert):
            return true
        default:
            return false
        }
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
    let numpadItemNormal = NumpadItem(value: .normal, selected: true)
    let numpadItemDraft = NumpadItem(value: .draft)
    
    @Published var draft: Bool {
        didSet {
            numpadItemDraft.selected = self.draft
            numpadItemNormal.selected = !self.draft
        }
    }
    
    @Published var finished: Bool
    
    init() {
        data = BoardData()
        solver = Solver(data: self.data)
        generator = Generator(data: data, solver: solver)
        finished = false
        draft = false
    }
    
    func solve() {
        data.grid.enumerated().forEach { index, item in
            if !item.fixed {
                item.number = data.solution[index]
            }
        }
        updateNumpad()
    }
    
    func clearAll() {
        data.grid.forEach { if !$0.fixed { $0.number = 0 } }
        updateNumpad()
    }
    
    func clearSelected() {
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
        
        //row
//        self.data.row(at: row).forEach { $0.highlighted = true }
        
        // column
//        self.data.column(at: column).forEach { $0.highlighted = true }
        
        // neighbourhood
//        self.data.neigbourhood(at: row, column).forEach { $0.highlighted = true }
        
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
        
        save();
                
        if validate(number: selectedItem.number, atRow: selectedRow, column: selectedColumn) {
            selectedItem.error = false
            validateBoard();
        } else {
            selectedItem.error = true
        }
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
    
    func generate(difficulty: GameDifficulty) {
        generator.generate(countOfRemovable: 40)
        updateNumpad()
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            UserDefaults.standard.set(encodedData, forKey: "saved")
        } catch {
            debugPrint(error)
        }
    }
        
    func load() {
        guard let encodedData = UserDefaults.standard.data(forKey: "saved") else {
            debugPrint("Missing data. Re-generate.")
            // FIXME: handle error properly
//            generate()
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            data = try decoder.decode(BoardData.self, from: encodedData)
            selectedItem = data.selectedItem()
            selectedRow = data.selectedRow()
            selectedColumn = data.selectedColumn()
            
            if selectedRow != nil && selectedColumn != nil {
                highlight(row: selectedRow!, column: selectedColumn!)
            }
            
            updateNumpad()
            
        } catch {
            debugPrint("Decoding failed. Re-generate.")
            // FIXME: handle error properly
//            generate()
        }
    }
}
