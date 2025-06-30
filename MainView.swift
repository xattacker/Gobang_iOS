//
//  MainView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct MainView: View, CustomNavigationDisplayer
{
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
    
//    var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
//    {
//        return .large
//    }
    
    var navigationRightItems: [CustomNavigationItem]?
    {
        return [
            CustomNavigationItem(style: .title(title: "action", color: .blue), action: {
                print("action")
            })
        ]
    }
    
    var body: some View
    {
        return CustomViewContainer(
                content: {
                },
                navigationDisplayer: self)
    }
}
