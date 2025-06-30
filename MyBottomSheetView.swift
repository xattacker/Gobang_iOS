//
//  MyBottomSheetView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/12/27.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI

struct MyBottomSheetView: View {
    var body: some View {
        VStack {
            Text("This is a Bottom Sheet").font(.title)
                .padding(.top, 16)
                .padding(.bottom, 16)
            Image("apple-stock-forecast-us")
                .resizable()
                .scaledToFit()
            Text("Although it works, if you want to use presentation detents in a complex view it can become much harder to read. I would much prefer to keep the availability checks out of my main view logic. A different approach would be to write a custom view modifier that handles this once. I can then use the custom view modifier similarly to the original presentationDetents modifier:")
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}
