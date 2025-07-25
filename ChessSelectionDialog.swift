//
//  ChessSelectionDialog.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/2.
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


struct ChessSelectionDialog: View {
    let onSelected: (_ type: ChessSelectionType) -> Void
    
    var body: some View {
        Color.black.opacity(0.35)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 16) {
            HStack {
                Text("CHESS_SELECTION".localized)
                    .font(.title2)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Divider()
            
            // 單選選項
            ForEach(ChessSelectionType.allCases) {
                type in
                if type != .none
                {
                    Button {
                        onSelected(type)
                    } label: {
                        HStack {
                            ChessView(chessType: type)
                                .frame(width: 30, height: 30)
                            Text(type.name)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
