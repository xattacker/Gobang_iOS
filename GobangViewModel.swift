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
    func onCreateGrid(x: Int, y: Int) -> GobangGrid?
    func onPlayerWon(winner: PlayerType)
}


final class GobangViewModel
{
    private var selectedGridView: GridView?
    
    private var logic: GobangLogic!
    private var delegate: GobangViewModelDelegate?
    
    private var recorder = GradeRecorder()

    init(gridDimension: Int, delegate: GobangViewModelDelegate)
    {
        self.delegate = delegate
        
        self.logic = GobangLogic(delegate: self, dimension: gridDimension)
        self.logic.restart()
    }
    
    @MainActor
    func updateSelectedGridView(_ gridView: GridView)
    {
        self.selectedGridView?.selected = false
        
        gridView.selected = true
        self.selectedGridView = gridView
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
        // by pass to delegate
        return self.delegate?.onCreateGrid(x: x, y: y)
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
