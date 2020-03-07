//
//  BoardCell.swift
//  Sudoku
//
//  Created by Mark Sinkovics on 2020. 02. 26..
//  Copyright © 2020. Mark Sinkovics. All rights reserved.
//

import SwiftUI

struct BoardCell: View {
    
    @EnvironmentObject var item: Item
            
    var body: some View {
        GeometryReader { geometry in
            Text("\(self.item.number)")
                .font(Font.system(size: 30))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .border(Color.black, width: self.item.selected ? 4 : 1)
        }
    }
}

struct BoardCell_Previews: PreviewProvider {
    
    private static var item = Item()
    
    static var previews: some View {
        BoardCell()
            .environmentObject(item)
    }
}
