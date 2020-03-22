//
//  BoardCell.swift
//  Sudoku
//
//  Created by Mark Sinkovics on 2020. 02. 26..
//  Copyright © 2020. Mark Sinkovics. All rights reserved.
//

import SwiftUI

struct BoardCell: View {
    
    @ObservedObject var item: Item
        
    func borderColor() -> Color {
        self.item.selected ? Color(.systemRed) : Color.black
    }
    
    func borderSize() -> CGFloat {
        self.item.selected ? 4 : 1
    }
            
    var body: some View {
        GeometryReader { geometry in
            Text(self.item.str)
                .font(Font.system(size: 30))
                .foregroundColor(Color(.label))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .border(self.borderColor(), width: self.borderSize())
                .background(self.item.fixed ? Color(.systemTeal) : Color(.systemFill) )
        }
    }
}

struct BoardCell_Previews: PreviewProvider {
    
    private static var item: Item = Item()

    static var previews: some View {
        BoardCell(item: item)
    }
}
