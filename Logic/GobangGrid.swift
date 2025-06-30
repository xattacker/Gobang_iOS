//
//  GobangGrid.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


final class GobangGrid {
    private let paintAgent: GobangGridPaintAgent

    private(set) var x: Int = 0
    private(set) var y: Int = 0

    internal var edge: Int = 0

    private weak var logicAgent: GirdLogicAgent?

    var type: PlayerType = .none {
        didSet {
            if oldValue != type {
                paint()

                if type == .player {
                    logicAgent?.onGridDone(grid: self)
                }
            }
        }
    }

    var connectedDirection: ConnectedDirection? = nil {
        didSet {
            paint()
        }
    }

    init(paintAgent: GobangGridPaintAgent) {
        self.paintAgent = paintAgent
    }

    internal func initial() {
        self.type = .none
        self.connectedDirection = .nilDirection
        paint()
    }

    internal func setXY(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    internal func setLogicAgent(_ agent: GirdLogicAgent) {
        self.logicAgent = agent
    }

    private func paint() {
        paintAgent.onPaint(self)
    }
}
