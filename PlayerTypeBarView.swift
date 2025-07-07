//
//  PlayerTypeBarView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/7.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct PlayerTypeBarView: View {
    @Binding var selectedChessType: ChessSelectionType?
    
    var body: some View {
        HStack {
            Text("PLAYER".localized)
                .foregroundColor(.blue)
                .font(.body)
            ChessView(chessColor: selectedChessType?.displayColor ?? .clear)
                .frame(width: 40, height: 40)
                .padding(.trailing, 20)
            
            Text("OPPONENT".localized)
                .foregroundColor(.red)
                .font(.body)
            ChessView(chessColor: selectedChessType?.theOther.displayColor ?? .clear)
                .frame(width: 40, height: 40)
        }
    }
}
