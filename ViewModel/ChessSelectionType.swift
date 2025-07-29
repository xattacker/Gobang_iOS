//
//  ChessSelectionType.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/29.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


enum ChessSelectionType: String, CaseIterable, Identifiable {
    case none
    
    case black = "BLACK_CHESS"
    case white = "WHITE_CHESS"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue.localized }
    
    var chessColor: Color {
        switch self {
            case .none:
                return Color.clear
            
            case .black:
                return Color("color_chess_black")
            
            case .white:
                return Color("color_chess_white")
        }
    }
    
    var borderColor: Color {
        switch self {
            case .none:
                return Color.clear
            
            case .black:
                return Color("color_border_black")
            
            case .white:
                return Color("color_border_white")
        }
    }
    
    var theOther: ChessSelectionType
    {
        switch self {
            case .none:
                return self
            
            case .black:
                return ChessSelectionType.white
            
            case .white:
                return ChessSelectionType.black
        }
    }
}
