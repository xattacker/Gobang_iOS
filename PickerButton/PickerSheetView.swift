//
//  PickerSheetView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/2/3.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct PickerSheetView: View {
    @State private var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    private let selections: [PickerSelectionItem]
    private let selectionTitle: String

    private weak var customDisplayer: PickerButtonCustomDisplayer?
    private var onSelected: ((_ item: PickerSelectionItem, _ index: Int) -> Void)?
    
    init(selections: [PickerSelectionItem],
         selectionTitle: String,
         selectedIndex: Int,
         displayer: PickerButtonCustomDisplayer?,
         onSelected: @escaping ((_ item: PickerSelectionItem, _ index: Int) -> Void)) {
        self.selections = selections
        self.selectionTitle = selectionTitle
        self.selectedIndex = selectedIndex
        
        self.customDisplayer = displayer
        self.onSelected = onSelected
    }

    var body: some View {
        SheetSelectionViewContainer(content: {
            Picker("", selection: $selectedIndex) {
                ForEach(0 ..< selections.count, id: \.self) {
                    index in
                    let selection = selections[index]

                    if let view = self.customDisplayer?.getPickerItemView(item: selection, index: index)
                    {
                        view
                    }
                    else
                    {
                        Text(selection.name)
                    }
                }
            }
            .pickerStyle(.wheel)
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
                
                if self.selectedIndex <= self.selections.count
                {
                    self.onSelected?(self.selections[self.selectedIndex], self.selectedIndex)
                }
            })
        )
    }
}
