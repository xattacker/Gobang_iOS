//
//  ConnectedDirection.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/6/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


enum ConnectedDirection: Int, CaseIterable {
    case lt_rb = 0       // 左上 → 右下
    case rt_lb = 1       // 右上 → 左下
    case horizontal = 2  // 橫向
    case vertical = 3    // 直向
    
    var value: Int {
        return self.rawValue
    }

    func next() -> ConnectedDirection? {
        return ConnectedDirection(rawValue: self.rawValue + 1)
    }

    func offset() -> (x: Int, y: Int) {
        switch self {
        case .lt_rb:
            return (1, 1)
        case .rt_lb:
            return (1, -1)
        case .horizontal:
            return (0, 1)
        case .vertical:
            return (1, 0)
        default:
            return (0, 0)
        }
    }

    static func parse(_ value: Int) -> ConnectedDirection? {
        return ConnectedDirection(rawValue: value)
    }
}
