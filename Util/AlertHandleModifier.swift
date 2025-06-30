//
//  AlertHandleModifier.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//
import SwiftUI


struct AlertHandleModifier: ViewModifier {
    struct ButtonInfo {
        let title: String // 按鈕標題
        var role: ButtonRole? = nil // 按鈕樣式
        var action: () -> Void = { } // 事件
    }
    
    @State private var isAlertPresented: Bool = false // 開啟 Alert 頁面識別
    private var showAlertTime: TimeInterval = 0 // 顯示 index, 異動項目時觸發 isAlertPresented true, 開啟提示視窗頁面
    
    @State private var isBottmSheetPresented: Bool = false // 開啟 Alert 頁面識別
    private var showBottmSheetTime: TimeInterval = 0 // 顯示 index, 異動項目時觸發 isBottmSheetPresented true, 開啟提示視窗頁面
    
    private var title: String = "" // 標題
    private var message: String = "" // 副標題
    private var buttons: [AlertHandleModifier.ButtonInfo] = [] // 按鈕項目

    func body(content: Content) -> some View {
        content.alert(
                self.title,
                isPresented: $isAlertPresented,
                actions: {
                    if !buttons.isEmpty {
                        ForEach(0 ..< buttons.count, id: \.self) {
                            index in
                            let info = buttons[index]
                            Button(info.title,
                                   role: info.role,
                                   action: info.action)
                        }
                    }
                },
                message: {
                    Text(message)
                })
                .onChange(of: showAlertTime, perform: {
                    newValue in
                    self.isAlertPresented.toggle()
                })
                .confirmationDialog(self.title, isPresented: $isBottmSheetPresented, titleVisibility: .visible) {
                    if !buttons.isEmpty {
                        ForEach(0 ..< buttons.count, id: \.self) {
                            index in
                            let info = buttons[index]
                            Button(info.title,
                                   role: info.role,
                                   action: info.action)
                        }
                    }
                }
                .onChange(of: showBottmSheetTime, perform: {
                    newValue in
                    self.isBottmSheetPresented.toggle()
                })
    }

    mutating func showAlert(_ title: String, message: String, buttons: [AlertHandleModifier.ButtonInfo]) {
        self.title = title // 標題
        self.message = message // 副標題
        self.buttons = buttons // 按鈕項目
          
        self.showAlertTime = Date().timeIntervalSince1970
        // 直接改 isAlertPresented 沒效果
        //self.isAlertPresented.toggle()
    }
    
    mutating func showBottomSheetAlert(_ title: String, buttons: [AlertHandleModifier.ButtonInfo]) {
        self.title = title // 標題
        self.buttons = buttons // 按鈕項目
          
        self.showBottmSheetTime = Date().timeIntervalSince1970
        // 直接改 isBottmSheetPresented 沒效果
        //self.isBottmSheetPresented.toggle()
    }
}
