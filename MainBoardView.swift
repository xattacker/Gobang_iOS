//
//  MainBoardView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct MainBoardView: View, ChessStyleMediator, GobangGridPaintAgent, @preconcurrency GobangViewModelDelegate
{
    private let GRID_DIMENSION = 14
    
    private var grids = Array<Array<GobangGrid>>()
    @State private var viewModel: GobangViewModel!
    
    init() {
        for _ in 0 ..< GRID_DIMENSION {
            var subs = Array<GobangGrid>()
            for _ in 0 ..< GRID_DIMENSION {
                let grid = GobangGrid(paintAgent: self)
                subs.append(grid)
            }
            
            self.grids.append(subs)
        }
        
        self.viewModel = GobangViewModel(gridDimension: GRID_DIMENSION, delegate: self)
    }
   
    var body: some View
    {
        return VStack(spacing: 0) {
                // 上區塊（固定高度）
                Text("🔝 上區")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)

                // 中區塊（填滿剩餘空間）
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach(0 ..< GRID_DIMENSION) {
                            y in
                            HStack(spacing: 0) {
                                ForEach(0 ..< GRID_DIMENSION) {
                                    x in
                                    GridView(grid: grids[x][y], mediator: self) {
                                        print("onTap")
                                    }.aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                    }.background(Color("board_background"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)

                // 下區塊（固定高度）
                Text("🔻 下區")
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
            }
    }
    
    nonisolated func onPaint(grid: GobangGrid)
    {
    }
    
    nonisolated func getChessColor(type: PlayerType) -> Color
    {
        switch type {
            case .computer:
                return .red
                
            case .player:
                return .blue
                
            case .none:
                return .white
        }
    }
    
    @MainActor
    func onCreateGrid(x: Int, y: Int) -> GobangGrid? {
        return self.grids[x][y]
    }
}
