//
//  GobangGridPaintAgent.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


protocol GobangGridPaintAgent: AnyObject {
    func onPaint(grid: GobangGrid)
}
