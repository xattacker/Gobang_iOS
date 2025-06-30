//
//  GirdLogicAgent.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


protocol GirdLogicAgent: AnyObject
{
    func onGridDone(grid: GobangGrid)
}
