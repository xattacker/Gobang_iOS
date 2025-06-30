//
//  DynamicBottomSheetViewContainer.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/12/27.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI


struct BottomSheetViewDragIndicatorStyle
{
    let show: Bool
    let color: Color
    
    static var hidden: BottomSheetViewDragIndicatorStyle
    {
        return BottomSheetViewDragIndicatorStyle(show: false, color: .clear)
    }
}


struct DynamicBottomSheetViewContainer<Content: View>: View {
    @State private var detentHeight: CGFloat = 0
    
    private let content: Content
    private let dragIndicatorStyle: BottomSheetViewDragIndicatorStyle
    private let interactiveDismiss: Bool

    init(@ViewBuilder content: () -> Content,
         dragIndicatorStyle: BottomSheetViewDragIndicatorStyle = BottomSheetViewDragIndicatorStyle(show: true, color: .secondary),
         interactiveDismiss: Bool = true) {
        self.content = content()
        self.dragIndicatorStyle = dragIndicatorStyle
        self.interactiveDismiss = interactiveDismiss
    }
    
    var body: some View {
        if #available(iOS 16, *)
        {
            self.content
                .getHeight()
                .onPreferenceChange(HeightPreferenceKey.self) {
                    height in
                    if let height {
                        self.detentHeight = height
                    }
                }
            .presentationDetents([.height(self.detentHeight)])
            .presentationDragIndicator(.hidden) // 禁止顯示系統預設拖動指示器
            .interactiveDismissDisabled(!self.interactiveDismiss) // 是否禁用下拉關閉
            .overlay(
                   // 自定義拖動指示器
                   RoundedRectangle(cornerRadius: 2)
                       .frame(width: 38, height: 4)
                       .foregroundColor(self.dragIndicatorStyle.show ? self.dragIndicatorStyle.color : .clear) // 自定義顏色
                       .padding(.top, 6),
                   alignment: .top
               )
//            .onChange(of: self.detentHeight) {
//                newHeight in
//                print("newHeight: \(newHeight)")
//            }
            /*
             https://www.appcoda.com.tw/swiftui-bottom-sheet-background/
            .medium
            視圖顯示在屏幕中間高度（類似於 50% 的屏幕高度）。
            適合部分內容顯示或簡短操作。
            
            .large
            視圖佔滿整個屏幕（幾乎全屏）。
            適合更複雜的內容或需要用戶更多交互的場景。
            
            .fraction(0.XX)
            自定義高度，通過屏幕高度的百分比設定（例如 0.5 表示 50%）。
             */
        }
        else
        {
            self.content
        }
     }
}
