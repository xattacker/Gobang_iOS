//
//  PickerButton.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


protocol PickerButtonCustomDisplayer: AnyObject
{
    func getButtonView(title: String) -> AnyView?
    func getPickerItemView(item: PickerSelectionItem, index: Int) -> AnyView?
}

extension PickerButtonCustomDisplayer
{
    func getButtonView(title: String) -> AnyView?
    {
        return AnyView(
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.body)
            )
    }
}

struct PickerSelectionItem
{
    let name: String
    var boundObject: Any?
}

struct PickerButtonSelectionParams
{
    let selections: [PickerSelectionItem]
    let selectionTitle: String
    var selectedIndex: Int?
}


struct PickerButton: View {
    @State private var showPickerSheet = false

    @State private var selectedIndex: Int = 0
    private let selections: [PickerSelectionItem]
    private let selectionTitle: String
    
    private let customDisplayer: PickerButtonCustomDisplayer?
    private var itemSelected: ((_ item: PickerSelectionItem, _ index: Int) -> Void)?
    
    init(params: PickerButtonSelectionParams,
         displayer: PickerButtonCustomDisplayer? = nil,
         itemSelected: @escaping ((_ item: PickerSelectionItem, _ index: Int) -> Void)) {
        self.selections = params.selections
        self.selectionTitle = params.selectionTitle
        
        if let index = params.selectedIndex, index >= 0, index < selections.count
        {
            self.selectedIndex = index
        }
        
        self.customDisplayer = displayer
        self.itemSelected = itemSelected
    }
    
    var body: some View {
        Button(action: {
            showPickerSheet.toggle()
        }) {
            let title = self.shownTitle
            
            if let view = self.customDisplayer?.getButtonView(title: title)
            {
                view
            }
            else
            {
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
        }
        .sheet(isPresented: $showPickerSheet) {
            DynamicBottomSheetViewContainer(
             content: {
                 PickerSheetView(
                    selections: self.selections,
                    selectionTitle: self.selectionTitle,
                    selectedIndex: self.selectedIndex,
                    displayer: self.customDisplayer) {
                        item, index in
                        self.selectedIndex = index
                        self.itemSelected?(item, index)
                    }
             },
             dragIndicatorStyle: BottomSheetViewDragIndicatorStyle.hidden,
             interactiveDismiss: false)
           }
    }
    
    private var shownTitle: String
    {
        let str = self.selections[self.selectedIndex].name
        return str
    }
}
