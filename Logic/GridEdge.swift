//
//  GridEdge.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


struct GridEdge: OptionSet {
    let rawValue: Int

    static let center  = GridEdge([])
    static let top     = GridEdge(rawValue: 0x00000001)
    static let bottom  = GridEdge(rawValue: 0x00000010)
    static let left    = GridEdge(rawValue: 0x00000100)
    static let right   = GridEdge(rawValue: 0x00001000)
}
