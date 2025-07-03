//
//  ToastView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/3.
//  Copyright © 2025 Xattacker. All rights reserved.
//
import SwiftUI


struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .transition(.move(edge: .bottom)
            .combined(with: .opacity))
    }
}
