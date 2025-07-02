//
//  ChessSelectionDialog.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/2.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


enum ChessColor: String, CaseIterable, Identifiable {
    case black = "BLACK_CHESS"
    case white = "WHITE_CHESS"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue.localized }
    
    var displayColor: Color {
        switch self {
            case .black:
                return Color("color_chess_black")
            case .white:
                return Color("color_chess_white")
        }
    }
    
    var theOther: ChessColor
    {
        switch self {
            case .black:
                return ChessColor.white
            case .white:
                return ChessColor.black
        }
    }
}

struct ChessSelectionDialog: View {
    @Binding var isPresented: Bool
    @Binding var selectedColor: ChessColor?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("CHESS_SELECTION".localized)
                    .font(.title2)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Divider()
            
            // 單選選項
            ForEach(ChessColor.allCases) {
                color in
                Button {
                    selectedColor = color
                    isPresented = false
                } label: {
                    HStack {
                        ChessView(chessColor: color.displayColor)
                            .frame(width: 24, height: 24)
                        Text(color.name)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
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
