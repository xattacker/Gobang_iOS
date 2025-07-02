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
}


final class GobangViewModel
{
    private var logic: GobangLogic!
    private var delegate: GobangViewModelDelegate?

    init(gridDimension: Int, delegate: GobangViewModelDelegate)
    {
        self.delegate = delegate
        
        self.logic = GobangLogic(delegate: self, dimension: gridDimension)
        self.logic.restart()
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
    }
}
