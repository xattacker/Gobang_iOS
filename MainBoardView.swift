//
//  MainBoardView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct MainBoardView: View, CustomNavigationDisplayer
{
    private let GRID_DIMENSION = 14
    
    init() {
    }
    
    var navigationTitle: String
    {
        return "ListView"
    }
    
    var navigationTitleColor: Color
    {
        return .green
    }
    
    var navigationBarColor: Color
    {
        return .yellow
    }

    var body: some View
    {
        return CustomViewContainer(
                content: {
                },
                navigationDisplayer: self)
    }
}
