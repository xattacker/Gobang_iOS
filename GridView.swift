//
//  GridView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/2/11.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI

fileprivate struct GirdInfo
{
    let title: String
}


struct GridView: View, CustomNavigationDisplayer
{
    private let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    private let gridInfos: [GirdInfo]
    
    init()
    {
        var infos = [GirdInfo]()
        for i in 0 ... 10
        {
            let info = GirdInfo(title: "\(i+1)")
            infos.append(info)
        }
        
        self.gridInfos = infos
    }
    
    var navigationTitle: String
    {
        return "GridView"
    }
    
    var body: some View {
        return CustomViewContainer(
                content: {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0 ..< gridInfos.count, id: \.self) {
                            index in
                            let info = gridInfos[index]
                            Text(info.title)
                                .frame(width: 80, height: 80)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                },
                navigationDisplayer: self)
    }
}
