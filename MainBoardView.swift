//
//  MainBoardView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct MainBoardView: View, ChessStyleMediator, @preconcurrency GobangViewModelDelegate
{
    private let GRID_DIMENSION = 14
    
    private var grids = Array<Array<GobangGrid>>()
    private var viewModel: GobangViewModel!
    @State private var refreshKey = UUID()
    
    init() {
        for _ in 0 ..< GRID_DIMENSION {
            var subs = Array<GobangGrid>()
            for _ in 0 ..< GRID_DIMENSION {
                let grid = GobangGrid()
                subs.append(grid)
            }
            
            self.grids.append(subs)
        }
        
        self.viewModel = GobangViewModel(gridDimension: GRID_DIMENSION, delegate: self)
    }
   
    var body: some View
    {
        return VStack(spacing: 0) {
                // 中區塊（填滿剩餘空間）
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach(0 ..< GRID_DIMENSION) {
                            y in
                            HStack(spacing: 0) {
                                ForEach(0 ..< GRID_DIMENSION) {
                                    x in
                                    GridView(grid: grids[x][y], mediator: self) {
                                    }.aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                    }.background(Color("board_background"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            
              }.background(Color.white)
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
