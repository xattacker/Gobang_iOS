//
//  GobangRecordSource.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/8/2.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


struct GobangGridRecord
{
    let type: PlayerType
    let x: Int
    let y: Int
}

// 棋局記錄來源介面定義
protocol GobangRecordSource
{
    func getGridRecord() -> [GobangGridRecord]
}


final internal class MockGobangRecordSource: GobangRecordSource
{
    func getGridRecord() -> [GobangGridRecord]
    {
        var records = [GobangGridRecord]()
        
        var r = GobangGridRecord(type: .computer, x: 9, y: 2)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 1, y: 1)
        records.append(r)
        
        
        r = GobangGridRecord(type: .computer, x: 2, y: 2)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 9, y: 1)
        records.append(r)
        
        
        r = GobangGridRecord(type: .computer, x: 3, y: 3)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 8, y: 1)
        records.append(r)
        
        
        r = GobangGridRecord(type: .computer, x: 4, y: 4)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 8, y: 4)
        records.append(r)
        
        
        r = GobangGridRecord(type: .computer, x: 5, y: 5)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 2, y: 1)
        records.append(r)
        
        
        r = GobangGridRecord(type: .computer, x: 0, y: 0)
        records.append(r)
        
        r = GobangGridRecord(type: .player, x: 2, y: 7)
        records.append(r)
        
        return records
    }
}
