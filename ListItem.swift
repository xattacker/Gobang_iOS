//
//  ListItem.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2019/10/9.
//  Copyright © 2019 Xattacker. All rights reserved.
//

import Foundation


final class ListItem: Identifiable
{
    /// unique id
    let id: String = UUID().uuidString
    
    var title: String?
}
