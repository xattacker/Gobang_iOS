//
//  ContentEntranceView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2019/10/9.
//  Copyright © 2019 Xattacker. All rights reserved.
//

import SwiftUI


struct ContentEntranceView: View, CustomNavigationDisplayer
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
    
    var showNavigationBar: Bool
    {
        return false
    }
    
    var showNavigationBack: Bool
    {
        return false
    }
    
    var body: some View
    {
        // Provides NavigationController
         return NavigationView {
                  // List inside the navigationController
                 CustomViewContainer(
                     content: {
                         VStack(spacing: 20) {
                             NavigationLink(destination: ListView()) {
                                 Text("List")
                             }
                             NavigationLink(destination: GridView()) {
                                 Text("Grid")
                             }
                             NavigationLink(destination: UIComponentDemoView()) {
                                 Text("UIComponentDemo")
                             }
                         }.padding()
                     },
                     navigationDisplayer: self)
                }
    }
}
