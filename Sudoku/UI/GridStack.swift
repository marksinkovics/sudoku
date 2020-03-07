//
//  GridStack.swift
//  Sudoku
//
//  Created by Mark Sinkovics on 2020. 02. 23..
//  Copyright © 2020. Mark Sinkovics. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {

    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
            
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0 ..< self.rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0 ..< self.columns, id: \.self) { column in
                            self.content(row, column)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
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
