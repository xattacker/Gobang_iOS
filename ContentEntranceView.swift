//
//  ContentEntranceView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct ContentEntranceView: View
{
    init() {
        // 设置 NavigationBar 全局样式
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.blue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
        
        // 自定义返回按钮图标
        appearance.setBackIndicatorImage(
            UIImage(named: "ic_nav_back_black"),
               transitionMaskImage: UIImage(named: "ic_nav_back_black")
           )

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UINavigationBar.appearance().tintColor = .black
    }
    
    var body: some View
    {
        // Provides NavigationController
         return NavigationView {
                  MainBoardView()
                }
    }
}
