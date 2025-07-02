//
//  ChessStyleMediator.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/1.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI

@MainActor
protocol ChessStyleMediator {
    func getChessColor(type: PlayerType) -> Color
}
