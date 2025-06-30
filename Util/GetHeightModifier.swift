//
//  GetHeightModifier.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/12/27.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI


struct HeightPreferenceKey: PreferenceKey {
    @MainActor static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct GetHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self,
                value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension View {
    func getHeight() -> some View {
        self.modifier(GetHeightModifier())
    }
}
