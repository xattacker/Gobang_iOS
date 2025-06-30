//
//  SheetSelectionViewContainer.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct SheetSelectionViewContainer<Content: View>: View {
    struct ButtonInfo {
        let title: String
        let action: () -> Void
    }
    
    private let title: String
    private let content: Content
    
    private let cancelButton: ButtonInfo
    private let confirmButton: ButtonInfo
    
    init(
        @ViewBuilder content: () -> Content,
        title: String,
        cancel: ButtonInfo,
        confirm: ButtonInfo) {
        self.title = title
        self.content = content()
            
        self.cancelButton = cancel
        self.confirmButton = confirm
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button(self.cancelButton.title) {
                    self.cancelButton.action()
                }.foregroundColor(.darkGray)
                Spacer()
                Text(self.title)
                    .font(.title2)
                    .foregroundColor(.black)
                Spacer()
                Button(self.confirmButton.title) {
                    self.confirmButton.action()
                }.foregroundColor(.darkGray)
            }.padding(.leading, 16)
             .padding(.trailing, 16)
             .padding(.top, 16)
             .padding(.bottom, 2)
            HStack {
                self.content
            }
        }
    }
}
