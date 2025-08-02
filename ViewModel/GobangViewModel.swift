//
//  GobangViewModel.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/1.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation
import SwiftUI


protocol GobangViewModelDelegate
{
    func onPlayerWon(winner: PlayerType)
}


final class GobangViewModel: ObservableObject
{
    private(set) var grids = Array<Array<GobangGrid>>()
    private var selectedGridView: GridView?
    
    private var logic: GobangLogic!
    var delegate: GobangViewModelDelegate?
    
    @Published private(set) var recorder = GradeRecorder()
    @Published var selectedChessType: ChessSelectionType?
    
    init(gridDimension: Int)
    {
        for _ in 0 ..< gridDimension {
            var subs = Array<GobangGrid>()
            for _ in 0 ..< gridDimension {
                let grid = GobangGrid()
                subs.append(grid)
            }
            
            self.grids.append(subs)
        }
        
        self.logic = GobangLogic(delegate: self, dimension: gridDimension)
    }
    
    @MainActor
    func updateSelectedGridView(_ gridView: GridView)
    {
        self.selectedGridView?.selected = false
        
        gridView.selected = true
        self.selectedGridView = gridView
    }
    
    func importRecord(_ source: GobangRecordSource)
    {
        self.logic.importRecord(source)
    }
    
    func restart()
    {
        self.logic.restart()
    }
    
    func undo()
    {
        self.logic.undo()
    }
}


extension GobangViewModel: GobangLogicDelegate
{
    func createGrid(x: Int, y: Int) -> GobangGrid?
    {
        return self.grids[x][y]
    }
    
    func onPlayerWon(winner: PlayerType)
    {
        switch winner {
            case .computer:
                self.recorder.addLose()
                break
            
            case .player:
                self.recorder.addWin()
                break
            
            default:
                break
        }
        
        // by pass to delegate
        self.delegate?.onPlayerWon(winner: winner)
    }
}
