//
//  SideMenuView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/5.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


enum SideMenuAction: CaseIterable
{
    case restart
    case undo
    
    var title: String
    {
        switch self {
            case .restart:
                return "RESTART".localized
            
            case .undo:
                return "UNDO".localized
        }
    }
}


struct SideMenuView: View {
    let onSelected: (_ action: SideMenuAction) -> Void
    let onClosed: () -> Void
    
    var body: some View {
        VStack {
            ForEach(SideMenuAction.allCases, id: \.self) {
                action in
                Button {
                    onSelected(action)
                } label: {
                    HStack {
                        Text(action.title)
                            .foregroundColor(.black)
                            .font(.body)
                            .padding(8)
                        Spacer()
                    }
                }
                Rectangle()
                    .fill(Color.systemGray5)
                    .frame(height: 1)
            }
            Spacer()
        }
        .contentShape(Rectangle()) // for tap detection
        .onTapGesture {
            onClosed()
        }
        .frame(maxWidth: .infinity, alignment: .leading) // 撐滿 SideMenuView 寬度
        .background(Color.white)
        .compositingGroup() // 陰影獨立於子內容渲染
        .shadow(radius: 5) // 這層加上陰影
    }
}
