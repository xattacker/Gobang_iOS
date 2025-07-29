//
//  ChessSelectionDialog.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/2.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct ChessSelectionDialog: View {
    let onSelected: (_ type: ChessSelectionType) -> Void
    
    var body: some View {
        Color.black.opacity(0.35)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 0) {
            HStack {
                Text("CHESS_SELECTION".localized)
                    .font(.title2)
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            
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
                                .frame(width: 40, height: 40)
                            Text(type.name)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                    }
                    .buttonStyle(HighlightButtonStyle())
                }
            }
        }
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}


fileprivate struct HighlightButtonStyle: ButtonStyle {
    let normalColor: Color = .white
    let highlightColor: Color = .systemGray5

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? highlightColor : normalColor)
            .foregroundColor(.white)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
