//
//  ChessBoardView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI

private let GRID_DIMENSION = 14

struct ChessBoardView: View, ChessStyleMediator, @preconcurrency GobangViewModelDelegate
{
    private enum GameStatus: Int, Identifiable
    {
        case unknown = -1
        // 選子
        case chessSelection = 0
        // 下子中
        case chessing = 1
        // 結束
        case over = 2
        
        var id: String { String(self.rawValue) }
    }
    
    private var grids = Array<Array<GobangGrid>>()
    @StateObject private var viewModel = GobangViewModel(gridDimension: GRID_DIMENSION)
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
    }
   
    var body: some View
    {
        return ZStack {
                    VStack(spacing: 0) {

                        VStack(spacing: 0) {
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
                            
                            VStack(spacing: 0) {
                                ForEach(0 ..< GRID_DIMENSION) {
                                    y in
                                    HStack(spacing: 0) {
                                        ForEach(0 ..< GRID_DIMENSION) {
                                            x in
                                            GridView(grid: grids[x][y], mediator: self) {
                                                view in
                                                viewModel.updateSelectedGridView(view)
                                            }.aspectRatio(1, contentMode: .fit)
                                        }
                                    }
                                }
                            }.background(Color("board_background"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.allowsHitTesting(self.gameStatus == .chessing) // 下子中才可以點擊
            
                    VStack {
                         Spacer()
                         HStack {
                              Spacer()
                              Text(String(format: "v %@", self.appVersion))
                              .foregroundColor(.darkGray)
                              .font(.caption)
                              .padding()
                         }
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
                self.viewModel.delegate = self
                self.viewModel.restart()
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
    
    func onPlayerWon(winner: PlayerType)
    {
        self.gameStatus = .over
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 3.5)

            DispatchQueue.main.async {
               self.gameStatus = .chessing
               self.viewModel.restart()
            }
        }
        
//        Task {
//            try? await Task.sleep(nanoseconds: 35 * 100_000_000) // 3.5 秒
////            self.gameStatus = .chessing
////            self.viewModel.restart()
//        }
    }
    
    private var appVersion: String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
}
