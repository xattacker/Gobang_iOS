//
//  GridView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/1.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct GridView: View {
    @ObservedObject var grid: GobangGrid
    let mediator: ChessStyleMediator
    let onTap: (_ view: GridView) -> Void
    
    @State var selected: Bool = false

    var body: some View {
        GeometryReader {
            geometry in
            let size = geometry.size.width
            let middle = size / 2

            ZStack {
                // ✅ 綠色選取背景
                if selected {
                    Path {
                        path in
                        path.addRect(CGRect(x: 0, y: 0, width: size, height: size))
                    }
                    .fill(Color.green)
                    .frame(width: size, height: size)
                }

                // ✅ 畫棋盤線（黑線）
                Path {
                    path in
                    let isTop = grid.edge.contains(GridEdge.top)
                    let isBottom = grid.edge.contains(GridEdge.bottom)
                    let isLeft = grid.edge.contains(GridEdge.left)
                    let isRight = grid.edge.contains(GridEdge.right)

                    let x1 = isLeft ? middle : 0
                    let x2 = isRight ? middle : size
                    let y1 = isTop ? middle : 0
                    let y2 = isBottom ? middle : size

                    // 中心十字線
                    path.move(to: CGPoint(x: x1, y: middle))
                    path.addLine(to: CGPoint(x: x2, y: middle))
                    path.move(to: CGPoint(x: middle, y: y1))
                    path.addLine(to: CGPoint(x: middle, y: y2))
                }
                .stroke(Color.black, lineWidth: 1)

                // ✅ 畫邊線灰線（依 GridEdge）
                Path {
                    path in
                    if grid.edge.contains(.top) {
                        path.move(to: .zero)
                        path.addLine(to: CGPoint(x: size, y: 0))
                    }
                    
                    if grid.edge.contains(.bottom) {
                        path.move(to: CGPoint(x: 0, y: size))
                        path.addLine(to: CGPoint(x: size, y: size))
                    }
                    
                    if grid.edge.contains(.left) {
                        path.move(to: .zero)
                        path.addLine(to: CGPoint(x: 0, y: size))
                    }
                    
                    if grid.edge.contains(.right) {
                        path.move(to: CGPoint(x: size, y: 0))
                        path.addLine(to: CGPoint(x: size, y: size))
                    }
                }
                .stroke(Color.gray, lineWidth: 1)

                // ✅ 棋子
                if grid.type != PlayerType.none {
                    ChessView(chessType: mediator.getChessType(playerType: grid.type),
                              edge: 2)
                        .frame(width: size, height: size)
                }

                // ✅ 勝利連線標記
                if let dir = grid.connectedDirection {
                    let edgeOffset = 0.0//size / 20

                    Path {
                        path in
                        switch dir {
                            case .lt_rb:
                                path.move(to: CGPoint(x: -edgeOffset, y: -edgeOffset))
                                path.addLine(to: CGPoint(x: size + edgeOffset * 2, y: size + edgeOffset * 2))
                                break
                            
                            case .rt_lb:
                                path.move(to: CGPoint(x: size, y: -edgeOffset))
                                path.addLine(to: CGPoint(x: -edgeOffset, y: size))
                                break
                            
                            case .horizontal:
                                path.move(to: CGPoint(x: middle, y: -edgeOffset))
                                path.addLine(to: CGPoint(x: middle, y: size))
                                break
                            
                            case .vertical:
                                path.move(to: CGPoint(x: -edgeOffset, y: middle))
                                path.addLine(to: CGPoint(x: size, y: middle))
                                break
                        }
                    }
                    .stroke(Color.red, style: StrokeStyle(lineWidth: size / 8, lineCap: .round))
                    //.drawingGroup()
                }
            }
            .contentShape(Rectangle()) // for tap detection
            .onTapGesture {
                if grid.type == .none {
                    grid.type = .player
                    onTap(self)
                }
            }
        }
    }
}

