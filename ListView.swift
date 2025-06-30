//
//  ListView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/1/16.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct ListView: View, CustomNavigationDisplayer
{
    private let items: [ListItem]
    
    init() {
        var items = [ListItem]()
        
        for i in 0 ... 100
        {
            let item = ListItem()
            item.title = "\(i)"
            items.append(item)
        }
        
        self.items = items
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
                    List(self.items) {
                            // loop through all the posts and create a post view for each item
                          item in
                        ListItemCellView(item: item)
                        }.listStyle(.plain)
                },
                navigationDisplayer: self)
    }
}
