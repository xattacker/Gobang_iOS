//
//  ChessView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/1.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI

struct ChessView: View {
    var chessColor: Color = .clear

    var body: some View {
        GeometryReader {
            geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size / 2 - 4

            ZStack {
                if chessColor != .clear {
                    Circle()
                        .fill(chessColor)
                        .frame(width: radius * 2, height: radius * 2)

                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: radius * 2, height: radius * 2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
