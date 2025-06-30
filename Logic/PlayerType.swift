//
//  PlayerType.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


enum PlayerType: Int {
    case none = -1
    case computer = 0
    case player = 1

    static func parse(_ value: Int) -> PlayerType {
        return PlayerType(rawValue: value) ?? .player
    }
}
