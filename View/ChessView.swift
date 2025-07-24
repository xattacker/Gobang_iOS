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
    var edge: Float = 2

    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                if chessColor != .clear {
                    // 棋子主體圓形
                    let width = geometry.size.width
                    let radius = (width / 2) - (CGFloat(edge) * 2)

                    ZStack {
                        // 陰影 + 主體
                        Circle()
                            .fill(chessColor)
                            .frame(width: radius * 2, height: radius * 2)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 4, y: 4) // 模擬 Android 的 setShadowLayer

                        // Radial 高光 (模擬反射光源)
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(0.9), .clear]),
                                    center: .init(x: 0.3, y: 0.3), // 模擬 cx - radius * 0.4, cy - radius * 0.4
                                    startRadius: 0,
                                    endRadius: radius
                                )
                            )
                            .frame(width: radius * 2, height: radius * 2)
                            .blendMode(.screen)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)

                    // 外框
//                    Circle()
//                        .stroke(Color.gray, lineWidth: 1)
//                        .frame(width: radius * 2, height: radius * 2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
