//
//  MultiPickerSheetView.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//


import SwiftUI
import Combine


struct MultiPickerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let pickerCount: Int
    private let selections: [any MultiPickerSelectable]
    private let selectionTitle: String
    
    @State private var selectedIndex1: Int
    @State private var selectedIndex2: Int
    @State private var selectedIndex3: Int

    private weak var customDisplayer: MultiPickerButtonCustomDisplayer?
    private var onSelected: ((_ selecteds: [(selected: any MultiPickerSelectable, index: Int)]) -> Void)?
    
    private var cancellable: AnyCancellable?

    init(pickerCount: Int,
         selections: [any MultiPickerSelectable],
         selectedIndexes: [Int],
         selectionTitle: String,
         displayer: MultiPickerButtonCustomDisplayer?,
         onSelected: @escaping ((_ selecteds: [(selected: any MultiPickerSelectable, index: Int)]) -> Void)) {
        self.pickerCount = pickerCount
        self.selections = selections
        self.selectionTitle = selectionTitle

        self.customDisplayer = displayer
        self.onSelected = onSelected
        
        var index1 = 0
        var index2 = 0
        var index3 = 0
        if selectedIndexes.count > 0
        {
            for (i, index) in selectedIndexes.enumerated()
            {
                switch i
                {
                    case 0:
                        index1 = index
                        break
                        
                    case 1:
                        index2 = index
                        break
                        
                    case 2:
                        index3 = index
                        break
                        
                    default:
                        break
                }
            }
        }
        
        self.selectedIndex1 = index1
        self.selectedIndex2 = index2
        self.selectedIndex3 = index3
    }

    var body: some View {
        SheetSelectionViewContainer(content: {
            ForEach(0 ..< self.pickerCount, id: \.self) {
                pickerIndex in
                Picker("", selection: getBindingIndex(pickerIndex)) {
                    let selections = self.getSelections(pickerIndex)
                    if selections.count > 0
                    {
                        ForEach(0 ..< selections.count, id: \.self) {
                            index2 in
                            let selection = selections[index2]
                            
                            if let view = self.customDisplayer?.getPickerItemView(item: selection, itemIndex: index2, pickerIndex: pickerIndex)
                            {
                                view
                            }
                            else
                            {
                                Text(selection.name)
                            }
                        }
                    }
                    else
                    {
                        // avoid out of index
                        Text("")
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: getSelectedIndex(pickerIndex)) {
                                newIndex in
                                if pickerIndex < (self.pickerCount - 1)
                                {
                                    for i in pickerIndex ..< self.pickerCount
                                    {
                                        let selections = self.getSelections(i+1)
                                        if selections.isEmpty
                                        {
                                            if i == 0
                                            {
                                                self.selectedIndex2 = -1
                                                self.selectedIndex3 = -1
                                                
                                                break
                                            }
                                            else if i == 1
                                            {
                                                self.selectedIndex3 = -1
                                                
                                                break
                                            }
                                        }
                                        else
                                        {
                                            if i == 0
                                            {
                                                self.selectedIndex2 = 0
                                            }
                                            else if i == 1
                                            {
                                                self.selectedIndex3 = 0
                                            }
                                        }
                                    }
                                }
                            }
            }
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
                
                var selected = [(selected: any MultiPickerSelectable, index: Int)]()
            
                for i in 0 ..< self.pickerCount
                {
                    let selectedIndex = self.getSelectedIndex(i)
                    let selections = self.getSelections(i)
                    
                    if selectedIndex >= 0 && selectedIndex < selections.count
                    {
                        selected.append((selections[selectedIndex], selectedIndex))
                    }
                }
            
                self.onSelected?(selected)
            })
        )
    }
    
    private func getBindingIndex(_ index: Int) -> Binding<Int>
    {
        switch index
        {
            case 0:
                return $selectedIndex1
                
            case 1:
                return $selectedIndex2
                
            case 2:
                return $selectedIndex3
            
            default:
                return $selectedIndex1
        }
    }
    
    private func getSelectedIndex(_ index: Int) -> Int
    {
        switch index
        {
            case 0:
                return selectedIndex1
                
            case 1:
                return selectedIndex2
                
            case 2:
                return selectedIndex3
            
            default:
                return selectedIndex1
        }
    }
    
    private func getSelections(_ pickerIndex: Int) -> [any MultiPickerSelectable]
    {
        if pickerIndex == 0
        {
            return self.selections
        }
        
        
        var parent: (any MultiPickerSelectable)?
        for i in 0 ... pickerIndex
        {
            let selectedIndex = self.getSelectedIndex(i)
            
            if i == 0
            {
                if selectedIndex >= 0 && self.selections.count > selectedIndex
                {
                    parent = self.selections[selectedIndex]
                }
            }
            else if i < pickerIndex, let subs = parent?.subs, selectedIndex >= 0 && subs.count > selectedIndex
            {
                parent = subs[selectedIndex]
            }
        }
        
        return parent?.subs ?? []
    }
}
