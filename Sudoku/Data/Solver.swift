import Foundation

class Solver {
     
    var data: BoardData
    
    init(data: BoardData) {
        self.data = data
    }
    
    func next(row: Int, column: Int) -> (row: Int, column: Int) {
        let nextIndex = (row * data.columns) + column + 1
        let nextRow = nextIndex / data.columns
        let nextColumn = nextIndex % data.columns
        return (row: nextRow, column: nextColumn)
    }
    
    @discardableResult
    func solve(atRow row: Int, column: Int) -> Bool {
        
        if row == data.rows || column == data.columns {
            return true
        }
        
        let possibleNumbers = data.possibleNumbers(at: row, column: column)
        let originalItem = data[row, column]
        
        
        if originalItem.fixed {
            let (nextRow, nextColumn) = next(row: row, column: column)
            if solve(atRow: nextRow, column: nextColumn) {
                return true
            }
            return false
        }
        
        let originalNumber = originalItem.number
        
        for possibleValue in possibleNumbers {
            data[row, column].number = possibleValue
            let (nextRow, nextColumn) = next(row: row, column: column)
            if solve(atRow: nextRow, column: nextColumn) {
                return true
            }
        }

        data[row, column].number = originalNumber
        return false
    }
}
