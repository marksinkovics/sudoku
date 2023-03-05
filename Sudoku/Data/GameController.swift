import SwiftUI

class GameController: ObservableObject {
    
    @Published var data: BoardData {
        didSet {
            selectedItem = data.selectedItem()
            selectedRow = data.selectedRow()
            selectedColumn = data.selectedColumn()
            highlight()
            updateNumpad()
        }
    }

    var selectedItem: Item?
    var selectedRow: Int?
    var selectedColumn: Int?
    let numpadItems: [NumpadItem] = (1...9).map { NumpadItem(value: .number($0)) }

    @EnvironmentObject var userSettings: UserSettings

    @AppStorage(UserSettings.Keys.highlightRow.rawValue) var highlightRow: Bool = false {
        didSet {
            highlight()
        }
    }
    @AppStorage(UserSettings.Keys.highlightColumn.rawValue) var highlightColumn: Bool = false {
       didSet {
           highlight()
       }
    }
    @AppStorage(UserSettings.Keys.highlightBlock.rawValue) var highlightBlock: Bool = false {
       didSet {
           highlight()
       }
   }
        
    @Published var draft: Bool = false
    @Published var finished: Bool = false
    @Published var shouldResettingAlert: Bool = false

    init() {
        data = BoardData()
    }

    init(data: BoardData) {
        self.data = data
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
        data.grid.forEach { if !$0.fixed { $0.number = 0; $0.error = false } }
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
        
        highlight()
    }
    
    func highlight() {
        guard let row = selectedRow, let column = selectedColumn else { return }

        data.unhighlightAll()

        if highlightRow {
            data.row(at: row).forEach { $0.highlighted = true }
        }
        
        if highlightColumn {
            data.column(at: column).forEach { $0.highlighted = true }
        }
        
        if highlightBlock {
            data.block(at: row, column).forEach { $0.highlighted = true }
        }
                
        // same numbers
        data.grid.filter { $0.number == selectedItem!.number }.forEach {
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
        highlight()
        updateNumpad()
                        
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
    
    func generate(difficulty: BoardData.Difficulty) {
        let generator = Generator()
        generator.generate(data: data, difficulty: difficulty)
        if let indexOfFirstNonFixedItem = data.grid.firstIndex(where: { !$0.fixed }) {
            let row = indexOfFirstNonFixedItem / data.columns
            let column = indexOfFirstNonFixedItem % data.columns
            select(row: row, column: column)
        }
        selectedItem = data.selectedItem()
        selectedRow = data.selectedRow()
        selectedColumn = data.selectedColumn()
        highlight()
        updateNumpad()
    }
}
