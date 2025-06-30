//
//  ListItemView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2019/10/9.
//  Copyright © 2019 Xattacker. All rights reserved.
//

import SwiftUI


struct ListItemCellView: View
{
    let item: ListItem
    
    var body: some View
    {
        /// main vertical stack view - contains upper stackview and image
        NavigationLink(destination: NextView(item: item)) {
            HStack {
                Image("ic_carinfo_person")
                Text(item.title ?? "")
            }
        }
    }
}
