//
//  GobangLogicDelegate.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


protocol GobangLogicDelegate: AnyObject {
    func createGrid(x: Int, y: Int) -> GobangGrid?
    func onPlayerWon(winner: PlayerType)
}
