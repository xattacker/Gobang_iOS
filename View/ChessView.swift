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
            ZStack {
                if chessColor != .clear {
                    let size = min(geometry.size.width, geometry.size.height)
                    let radius = (size / 2) - 4

                    // 棋子主體圓形
                    Circle()
                        .fill(chessColor)
                        .frame(width: radius * 2, height: radius * 2)
                        // 高光1：強烈光點（鏡面反射）
                        .overlay(
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.9), .clear]),
                                        center: .topLeading,
                                        startRadius: 0,
                                        endRadius: radius * 0.8
                                    )
                                )
                                .blendMode(.screen)
                        )
                        // 高光2：月牙形斜向光帶
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .white.opacity(0.5),
                                            .clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: radius * 0.2
                                )
                                .blur(radius: 1)
                                .offset(x: -radius * 0.2, y: -radius * 0.2)
                                .mask(Circle())
                        )
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2) // 外陰影

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
