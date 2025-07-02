//
//  GobangLogic.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation

class GobangLogic: GirdLogicAgent {
    private static let directionOffset: [[Int]] = [
        [-1, -1], [-1, 0], [-1, 1],
        [0, -1],         [0, 1],
        [1, -1], [1, 0], [1, 1]
    ]

    private var gridDimension: Int = 0
    private var step: Int = 0

    private var locX: Int = 0
    private var locY: Int = 0

    private var count: Int = 0
    private var x: Int = 0
    private var y: Int = 0
    private var offsetX: Int = 0
    private var offsetY: Int = 0

    private var direction: ConnectedDirection = .unknown
    private var histories: [GobangGrid] = []
    private var check: PlayerType = .none
    private var checkDirections = [Bool](repeating: false, count: 8)
    private var turn: PlayerType = .none
    private var over: Bool = false
    private var grids: [[GobangGrid?]]
    private weak var delegate: GobangLogicDelegate?

    init(delegate: GobangLogicDelegate, dimension: Int) {
        self.delegate = delegate
        self.gridDimension = dimension
        self.grids = Array(
            repeating: Array(repeating: nil, count: dimension),
            count: dimension
        )
    }

    func onGridDone(grid: GobangGrid) {
        guard !over else { return }

        locX = grid.x
        locY = grid.y

        if let g = grids[locX][locY] {
            histories.append(g)
        }

        winCheck()

        if !over {
            turn = .computer
            gobangAI()
        }
    }

    func restart() {
        turn = .player

        for i in 0..<gridDimension {
            for j in 0..<gridDimension {
                if grids[i][j] == nil {
                    if let grid = delegate?.createGrid(x: i, y: j) {
                        grid.setXY(x: i, y: j)
                        grid.logicAgent = self
                        
                        var edge = GridEdge.center

                        if i == 0 {
                            edge.insert(GridEdge.left)
                        }
                        else if i == gridDimension - 1 {
                            edge.insert(GridEdge.right)
                        }

                        if j == 0 {
                            edge.insert(GridEdge.top)
                        }
                        else if j == gridDimension - 1
                        {
                            edge.insert(GridEdge.bottom)
                        }

                        grid.edge = edge
                        grids[i][j] = grid
                    }
                }
                
                grids[i][j]?.initial()
            }
        }

        histories.removeAll()
        over = false
    }

    func undo() {
        if histories.count >= 2 {
            for _ in 0..<2 {
                histories.removeLast().initial()
            }
        }
    }

    private func winCheck() {
        check = turn
        direction = .lt_rb
        winCheck2()
    }

    private func winCheck2() {
        var steps: [[Int]] = []

        if locX.inBounds(0..<gridDimension),
           locY.inBounds(0..<gridDimension),
           grids[locX][locY]?.type == check {
            steps.append([locX, locY])
        }

        checkOffset()
        x = locX + offsetX
        y = locY + offsetY

        while x.inBounds(0..<gridDimension), y.inBounds(0..<gridDimension), grids[x][y]?.type == check {
            steps.append([x, y])
            x += offsetX
            y += offsetY
        }

        x = locX - offsetX
        y = locY - offsetY

        while x.inBounds(0..<gridDimension), y.inBounds(0..<gridDimension), grids[x][y]?.type == check {
            steps.append([x, y])
            x -= offsetX
            y -= offsetY
        }

        if steps.count >= 5
        {
            over = true
            
            steps.forEach {
                step in
                grids[step[0]][step[1]]?.connectedDirection = direction
            }
            
            delegate?.onPlayerWon(winner: check)
        }
        else
        {
            direction = direction.next()
            
            if direction != .unknown {
                winCheck2()
            }
        }
    }

    private func checkOffset() {
        let offset = direction.offset()
        offsetX = offset.0
        offsetY = offset.1
    }

    func gobangAI() {
        var play = true

        for _ in (1...2).reversed()
        {
            play.toggle()
            gobangAI4(player: play)
            
            if turn == .player
            {
                return
            }
        }

        for i in (4...7).reversed()
        {
            play.toggle()
            
            step = i / 2
            gobangAI2(player: play)
            
            if turn == .player
            {
                return
            }
        }

        gobangAI5()
        
        if turn != .player {
            gobangRandom()
        }
    }

    private func gobangRandom() {
        offsetY = 0

        repeat {
            offsetX = Int.random(in: 0..<8)
            x = locX + GobangLogic.directionOffset[offsetX][0]
            y = locY + GobangLogic.directionOffset[offsetX][1]

            if !checkDirections[offsetX] {
                offsetY += 1
                checkDirections[offsetX] = true
            }
        } while (!x.inBounds(0..<gridDimension) ||
                !y.inBounds(0..<gridDimension) ||
                grids[x][y]?.type != PlayerType.none) &&
                offsetY < 8

        checkDirections = [Bool](repeating: false, count: 8)

        if x.inBounds(0..<gridDimension), y.inBounds(0..<gridDimension), grids[x][y]?.type == PlayerType.none {
            setAIMark(x: x, y: y)
        } else {
            gobangRandom2()
        }
    }

    private func gobangRandom2() {
        repeat {
            x = Int.random(in: 0..<gridDimension)
            y = Int.random(in: 0..<gridDimension)
        } while grids[x][y]?.type != PlayerType.none

        setAIMark(x: x, y: y)
    }

    private func gobangAI2(player: Bool) {
        check = player ? .player : .computer

        for i in 0..<gridDimension {
            for j in 0..<gridDimension {
                if turn == .player { break }
                if grids[i][j]?.type == check {
                    count = 1
                    direction = .lt_rb
                    gobangAI3(x: i, y: j)
                }
            }
        }
    }

    private func gobangAI3(x: Int, y: Int) {
        var tempX = x
        var tempY = y
        if count == 1 {
            locX = tempX
            locY = tempY
        }

        checkOffset()
        tempX += offsetX
        tempY += offsetY

        if tempX.inBounds(0..<gridDimension), tempY.inBounds(0..<gridDimension), grids[tempX][tempY]?.type == check {
            count += 1
            if count == step {
                if (tempX + offsetX).inBounds(0..<gridDimension),
                   (tempY + offsetY).inBounds(0..<gridDimension),
                   grids[tempX + offsetX][tempY + offsetY]?.type == PlayerType.none {

                    if (tempX - step * offsetX).notInBounds(0..<gridDimension) ||
                       (tempY - step * offsetY).notInBounds(0..<gridDimension) ||
                       !gobangSpaceAI(x: tempX + offsetX, y: tempY + offsetY) ||
                        grids[tempX - step * offsetX][tempY - step * offsetY]?.type != PlayerType.none && step < 3 {
                        gobangAI3_2()
                    } else {
                        checkAIMark(x: tempX + offsetX, y: tempY + offsetY)
                    }
                } else {
                    gobangAI3_2()
                }
            } else {
                gobangAI3(x: tempX, y: tempY)
            }
        } else {
            gobangAI3_2()
        }
    }

    private func gobangAI3_2() {
        if direction != .vertical {
            count = 1
            direction = direction.next()
            gobangAI3(x: locX, y: locY)
        }
    }

    private func gobangAI4(player: Bool) {
        check = player ? .player : .computer

        for i in 0..<gridDimension {
            for j in 0..<gridDimension {
                if turn == .player { break }
                if grids[i][j]?.type == PlayerType.none {
                    direction = .lt_rb
                    locX = i
                    locY = j
                    gobangAI4()
                }
            }
        }
    }

    private func gobangAI4() {
        count = 0
        checkOffset()
        direction = direction.next()
        x = locX + offsetX
        y = locY + offsetY

        while x.inBounds(0..<gridDimension), y.inBounds(0..<gridDimension), grids[x][y]?.type == check {
            count += 1
            x += offsetX
            y += offsetY
        }

        x = locX - offsetX
        y = locY - offsetY

        while x.inBounds(0..<gridDimension), y.inBounds(0..<gridDimension), grids[x][y]?.type == check {
            count += 1
            x -= offsetX
            y -= offsetY
        }

        if count >= 4 {
            setAIMark(x: locX, y: locY)
        } else if direction != .unknown {
            gobangAI4()
        }
    }

    private func gobangAI5() {
        for i in 0..<gridDimension {
            for j in 0..<gridDimension {
                if turn == .player { break }
                if grids[i][j]?.type == .computer {
                    direction = .lt_rb
                    locX = i
                    locY = j
                    gobangAI5_2()
                }
            }
        }
    }

    private func gobangAI5_2() {
        count = 0
        checkOffset()
        direction = direction.next()
        x = locX + offsetX
        y = locY + offsetY

        while x.inBounds(0..<gridDimension),
              y.inBounds(0..<gridDimension),
              grids[x][y]?.type == PlayerType.none,
              count < 4 {
            count += 1
            x += offsetX
            y += offsetY
        }

        x = locX - offsetX
        y = locY - offsetY

        if count == 4,
           x.inBounds(0..<gridDimension),
           y.inBounds(0..<gridDimension),
           grids[x][y]?.type == PlayerType.none
        {
            setAIMark(x: locX + offsetX, y: locY + offsetY)
        } else if count > 1
        {
            if count == 4 { count = 3 }

            while x.inBounds(0..<gridDimension),
                  y.inBounds(0..<gridDimension),
                  grids[x][y]?.type == PlayerType.none,
                  count < 4 {
                count += 1
                x -= offsetX
                y -= offsetY
            }

            if count == 4
            {
                setAIMark(x: locX + offsetX, y: locY + offsetY)
            }
            else if direction != .unknown
            {
                gobangAI5_2()
            }
        }
        else if direction != .unknown
        {
            gobangAI5_2()
        }
    }

    private func gobangSpaceAI(x: Int, y: Int) -> Bool {
        var tempX = x
        var tempY = y
        var space = 0

        repeat {
            space += 1
            tempX += offsetX
            tempY += offsetY
        } while tempX.inBounds(0 ..< gridDimension) &&
                tempY.inBounds(0..<gridDimension) &&
                grids[tempX][tempY]?.type == PlayerType.none &&
                space < 4

        if space + count >= 5 {
            return true
        } else {
            space = 0
            tempX = locX - offsetX
            tempY = locY - offsetY

            while tempX.inBounds(0..<gridDimension) &&
                  tempY.inBounds(0..<gridDimension) &&
                  grids[tempX][tempY]?.type == PlayerType.none &&
                  space < 4 {
                space += 1
                tempX -= offsetX
                tempY -= offsetY
            }

            return space + count >= 5
        }
    }

    private func checkAIMark(x: Int, y: Int) {
        var space = 0
        var tempX = x
        var tempY = y

        repeat {
            space += 1
            tempX += offsetX
            tempY += offsetY
        } while tempX.inBounds(0..<gridDimension) &&
                tempY.inBounds(0..<gridDimension) &&
                grids[tempX][tempY]?.type == PlayerType.none &&
                space < 4

        if space + step >= 5 {
            setAIMark(x: x, y: y)
        } else {
            setAIMark(x: x - (step + 1) * offsetX, y: y - (step + 1) * offsetY)
        }
    }

    private func setAIMark(x: Int, y: Int) {
        if let grid = grids[x][y] {
            histories.append(grid)
            grid.type = .computer
        }
        
        winCheck()
        turn = .player
    }
}


extension Int {
    fileprivate func inBounds(_ range: Range<Int>) -> Bool {
        return range.contains(self)
    }
    
    fileprivate func notInBounds(_ range: Range<Int>) -> Bool {
        return !range.contains(self)
    }
}
