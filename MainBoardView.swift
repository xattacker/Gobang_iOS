//
//  MainBoardView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct MainBoardView: View, ChessStyleMediator, GobangGridPaintAgent
{
    nonisolated func onPaint(grid: GobangGrid) {
        
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
    
    private let GRID_DIMENSION = 14
    private let columns: Array<GridItem>
    private var grids = Array<GobangGrid>()
    
    private var viewModel: GobangViewModel
    
    init() {
        columns = Array(repeating: GridItem(.flexible()), count: GRID_DIMENSION)
        
        let total_count = GRID_DIMENSION * GRID_DIMENSION
        for _ in 0 ..< total_count {
            let grid = GobangGrid(paintAgent: self)
            grids.append(grid)
        }
        
        self.viewModel = GobangViewModel(gridDimension: GRID_DIMENSION,
                                         onCreateGrid: {
                                            x, y in
                                            
                                        })
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
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(0 ..< (GRID_DIMENSION * GRID_DIMENSION)) {
                                index in
                                GridView(grid: grids[index], mediator: self) {
                                    print("onTap")
                                }
                                .aspectRatio(1, contentMode: .fit)
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
}
