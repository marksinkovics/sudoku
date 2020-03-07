//
//  Numpad.swift
//  Sudoku
//
//  Created by Mark Sinkovics on 2020. 02. 29..
//  Copyright © 2020. Mark Sinkovics. All rights reserved.
//

import SwiftUI

struct Numpad: View {
    
    @EnvironmentObject var boardData: BoardData
    private var numpadItems = Array(1...9).map { Item(number: $0) }
        
    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 1, columns: self.numpadItems.count) { row, column in
                BoardCell()
                    .environmentObject(self.numpadItems[column])
                    .onTapGesture {
                        self.boardData.selectedItem()?.number = self.numpadItems[column].number
                    }
            }
        }
    }
}

struct Numpad_Previews: PreviewProvider {
    
    private static var boardData: BoardData = BoardData(rows: 9, columns: 9)

    static var previews: some View {
        Numpad()
        .environmentObject(boardData)
    }
}
