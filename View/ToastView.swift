//
//  ToastView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/3.
//  Copyright © 2025 Xattacker. All rights reserved.
//
import SwiftUI


enum ToastGravity: ViewModifier
{
    case top
    case center
    case bottom
    
    func body(content: Content) -> some View {
        switch self {
            case .top:
                content.padding(.top, 40)
            case .center:
                content
            case .bottom:
                content.padding(.bottom, 40)
        }
    }
}

struct ToastView: View {
    let message: String
    let gravity: ToastGravity

    var body: some View {
        VStack {
            if gravity == .bottom
            {
                Spacer()
            }
            
            Text(message)
                .foregroundColor(.white)
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .transition(.move(edge: .bottom)
                .combined(with: .opacity))
                .modifier(gravity)
            
            if gravity == .top
            {
                Spacer()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
