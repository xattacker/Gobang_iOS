//
//  DatePickerSheetView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/1/15.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct DatePickerSheetView: View {
    @State private var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    private let dateComponents: DatePicker.Components
    private let selectionTitle: String
    private var timeSelected: ((_ selectedDate: Date) -> Void)?
    
    init(date: Date,
         dateComponents: DatePicker.Components,
         selectionTitle: String,
         timeSelected: @escaping ((_ selectedDate: Date) -> Void)) {
        self.selectedDate = date
        self.dateComponents = dateComponents
        self.selectionTitle = selectionTitle
        self.timeSelected = timeSelected
    }

    var body: some View {
        SheetSelectionViewContainer(content: {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: self.dateComponents
            ).datePickerStyle(.wheel)
             .environment(\.locale, Locale(identifier: "zh_TW"))  // 以中文樣式顯示
             .labelsHidden() // 隱藏標籤
             .frame(maxWidth: .infinity) // 擴展框架寬度
             .clipped()
        },
        title: self.selectionTitle,
        cancel:
          SheetSelectionViewContainer.ButtonInfo(title: "取消",
               action: {
               dismiss()
           }),
        confirm:
           SheetSelectionViewContainer.ButtonInfo(title: "確認",
                action: {
                dismiss()
                
               timeSelected?(self.selectedDate)
            })
        )
    }
}
