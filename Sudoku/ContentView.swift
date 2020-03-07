//
//  ContentView.swift
//  Sudoku
//
//  Created by Mark Sinkovics on 2020. 02. 23..
//  Copyright © 2020. Mark Sinkovics. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private var boardData: BoardData = BoardData(rows: 9, columns: 9)
    
    var body: some View {
        VStack {
            Spacer()
            Board()
                .environmentObject(boardData)
                .aspectRatio(1.0, contentMode: .fit)
                .padding()
            Spacer()
            Numpad()
                .environmentObject(boardData)
                .aspectRatio(9/1, contentMode: .fit)
                .padding(.leading)
                .padding(.trailing)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    private static var boardData: BoardData = BoardData(rows: 9, columns: 9)

    static var previews: some View {
        ContentView()
            .environmentObject(boardData)
    }
}
