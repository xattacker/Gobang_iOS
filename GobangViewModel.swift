//
//  GobangViewModel.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/1.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation
import SwiftUI


final class GobangViewModel
{
    private var logic: GobangLogic!
    private var onCreateGrid: ((_ x: Int, _ y: Int) -> GobangGrid?)?

    init(gridDimension: Int, onCreateGrid: @escaping ((_ x: Int, _ y: Int) -> GobangGrid?)) {
        
        self.logic = GobangLogic(delegate: self, dimension: gridDimension)
        self.logic.restart()
        
        self.onCreateGrid = onCreateGrid
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
        return self.onCreateGrid?(x, y)
    }
    
    func onPlayerWon(winner: PlayerType)
    {
    }
}
