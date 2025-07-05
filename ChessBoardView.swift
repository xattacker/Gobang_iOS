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
    private enum GameStatus: Identifiable, Equatable
    {
        case unknown
        // 選子
        case chessSelection
        // 下子中
        case chessing
        // 結束
        case over(winner: PlayerType)
        
        var id: String {
            "\(self)"
        }
        
        public static func == (lhs: GameStatus, rhs: GameStatus) -> Bool
        {
            return lhs.id == rhs.id
        }
    }
    
    @StateObject private var viewModel = GobangViewModel(gridDimension: GRID_DIMENSION)
    @State private var gameStatus: GameStatus = .unknown
    @State private var selectedChessType: ChessSelectionType?
    
    @State private var alertHandler = AlertHandleModifier()
    @State private var isSideMenuOpen = false
    private let menuWidth: CGFloat = 140
    
    init() {
    }
   
    var body: some View
    {
        return ZStack(alignment: .trailing) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("WIN_COUNT".localized(self.viewModel.recorder.winCount, self.viewModel.recorder.loseCount))
                            .foregroundColor(.darkGray)
                            .font(.body)
                            .padding(8)
                            
                            Spacer()
                            
                            Button(
                                action: {
                                    isSideMenuOpen.toggle()
                                }){
                               Image(systemName: "line.horizontal.3")
                               .tint(Color.darkGray)
                               .font(.title)
                            }
                            .padding(.trailing, 8)
                        }
                        
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
                                            GridView(grid: self.viewModel.grids[x][y], mediator: self) {
                                                view in
                                                viewModel.updateSelectedGridView(view)
                                            }.aspectRatio(1, contentMode: .fit)
                                        }
                                    }
                                }
                            }.background(Color("board_background"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.allowsHitTesting(self.gameStatus == .chessing && !self.isSideMenuOpen) // 下子中才可以點擊
            
                    VStack {
                         Spacer()
                         HStack {
                              Spacer()
                              Text(String(format: "v %@", self.appVersion))
                              .foregroundColor(.darkGray)
                              .font(.caption)
                              .padding(8)
                         }
                    }
            
                switch self.gameStatus
                {
                    case .chessSelection:
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        ChessSelectionDialog {
                            type in
                            self.selectedChessType = type
                            self.gameStatus = .chessing
                        }
                        
                    case .over(let winner):
                        VStack {
                            Spacer()
                            ToastView(message: winner == .player ? "YOU_WIN".localized : "YOU_LOSE".localized)
                            .padding(.bottom, 40)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)

                    default:
                        Spacer()
                }
            
                // 側邊選單
                SideMenuView(onSelected: {
                    action in
                    switch action {
                        case .restart:
                            alertHandler.showAlert(
                                "CONFIRM_RESTART".localized,
                                message: "",
                                buttons: [
                                    AlertHandleModifier.ButtonInfo(
                                        title: "OK".localized,
                                        role: nil,
                                        action: {
                                            restartGame()
                                            isSideMenuOpen.toggle()
                                    }),
                                    AlertHandleModifier.ButtonInfo(
                                        title: "CANCEL".localized,
                                        role: .cancel,
                                        action: {
                                     })])
                            break
                        
                        case .undo:
                            viewModel.undo()
                            isSideMenuOpen.toggle()
                            break
                    }
                })
                .frame(width: menuWidth)
                .background(Color.white)
                .offset(x: isSideMenuOpen ? 0 : menuWidth)
                //.shadow(radius: 5)
                .animation(.easeInOut, value: isSideMenuOpen)
                .allowsHitTesting(self.gameStatus == .chessing) // 下子中才可以點擊
            }
            .background(Color.systemGray6)
            .modifier(alertHandler)
            .gesture(
                self.gameStatus == .chessing ? // 下子中才能拖拉選單
                DragGesture()
                    .onEnded {
                        value in
                        // 偵測右向左滑
                        if value.translation.width < -50 {
                            withAnimation {
                                isSideMenuOpen = true
                            }
                        } else if value.translation.width > 50 {
                            withAnimation {
                                isSideMenuOpen = false
                            }
                        }
                    } :
                nil
            )
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
    
    func onPlayerWon(winner: PlayerType)
    {
        self.gameStatus = .over(winner: winner)
        
//        DispatchQueue.global().async {
//            Thread.sleep(forTimeInterval: 3.5)
//
//            DispatchQueue.main.async {
//               self.gameStatus = .chessing
//               self.viewModel.restart()
//            }
//        }
        
        Task {
            try? await Task.sleep(nanoseconds: 35 * 100_000_000) // 3.5 秒
            
            Task {
                @MainActor in
                restartGame()
            }
        }
    }
    
    private func restartGame()
    {
        self.gameStatus = .chessing
        self.viewModel.restart()
    }
    
    private var appVersion: String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
}
