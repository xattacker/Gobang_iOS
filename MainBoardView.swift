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
    
    private enum GameStatus: Int, Identifiable
    {
        case unknown = -1
        // 選子
        case chessSelection = 0
        // 下子中
        case chessing = 1
        
        var id: String { String(self.rawValue) }
    }
    
    private var grids = Array<Array<GobangGrid>>()
    private var viewModel: GobangViewModel!
    @State private var refreshKey = UUID()
    
    @State private var gameStatus: GameStatus = .unknown
    @State private var selectedChessType: ChessSelectionType?
    
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
        return ZStack {
                    VStack(spacing: 0) {
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
                    }
                
                    if self.gameStatus == .chessSelection {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        ChessSelectionDialog {
                            type in
                            self.selectedChessType = type
                            self.gameStatus = .chessing
                        }
                    }
            }.background(Color.white)
            .onAppear {
                self.gameStatus = .chessSelection
            }
    }
    
    func getChessColor(type: PlayerType) -> Color
    {
        guard let color = self.selectedChessType else
        {
            return .clear
        }
        
        switch type {
            case .computer:
                return color.theOther.displayColor
                
            case .player:
                return color.displayColor
                
            case .none:
                return .clear
        }
    }
    
    func onCreateGrid(x: Int, y: Int) -> GobangGrid? {
        return self.grids[x][y]
    }
}
