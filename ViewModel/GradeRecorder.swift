//
//  GradeRecorder.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/2.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


protocol GradeRecord {
    var winCount: Int { get }
    var loseCount: Int { get }
}

final class GradeRecorder: GradeRecord, ObservableObject {
    @Published private(set) var winCount: Int = 0
    @Published private(set) var loseCount: Int = 0

    func addWin() {
        winCount += 1
    }

    func addLose() {
        loseCount += 1
    }

    func reset() {
        winCount = 0
        loseCount = 0
    }
}
