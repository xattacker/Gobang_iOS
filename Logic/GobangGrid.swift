//
//  GobangGrid.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation
import SwiftUI


final class GobangGrid: ObservableObject {
    private(set) var x: Int = 0
    private(set) var y: Int = 0

    @Published var type: PlayerType = .none {
        didSet {
            if self.type != oldValue
            {
                if self.type == .player {
                    logicAgent?.onGridDone(grid: self)
                }
            }
        }
    }

    @Published var connectedDirection: ConnectedDirection? = nil

    internal var edge: GridEdge = .center
    internal weak var logicAgent: GirdLogicAgent?

    internal func initial() {
        self.type = .none
        self.connectedDirection = nil
    }

    internal func setXY(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
