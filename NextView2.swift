//
//  NextView2.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/11/29.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI


struct NextView2: View, CustomNavigationDisplayer {
    private let item: ListItem
    
    init(item: ListItem) {
        self.item = item
    }
    
    var navigationTitle: String
    {
        return self.item.title ?? ""
    }
    
    var body: some View {
        CustomViewContainer(
            content: {
                VStack {
                    LineView()
                        .lineColor(Color.yellow)
                        .orientation(.horizontal)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 20)
                }.padding()
            },
            navigationDisplayer: self)
    }
}
