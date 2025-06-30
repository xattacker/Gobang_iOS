//
//  MultiPickerButton.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/06/30.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


// composite pattern
public protocol MultiPickerSelectable
{
    associatedtype SubSelectable: MultiPickerSelectable
    
    var id: String { get }
    var name: String { get }

    var subs: [SubSelectable]? { get }
}

extension MultiPickerSelectable
{
    public subscript(index: Int) -> SubSelectable?
    {
        return self.subs?.count ?? 0 > index ? self.subs?[index] : nil
    }
}

public struct MultiPickerItem: MultiPickerSelectable
{
    public typealias SubSelectable = MultiPickerItem
    
    public let id: String
    public let name: String
    
    public var subs: [MultiPickerItem]?
}


protocol MultiPickerButtonCustomDisplayer: AnyObject
{
    func getButtonView(selecteds: [any MultiPickerSelectable]) -> AnyView?
    func getPickerItemView(item: any MultiPickerSelectable, itemIndex: Int, pickerIndex: Int) -> AnyView?
}

extension MultiPickerButtonCustomDisplayer
{
    func getButtonView(selecteds: [any MultiPickerSelectable]) -> AnyView?
    {
        return AnyView(
            Text(selecteds.reduce("", { $0 + ($0.count > 0 ? " - " : "") + $1.name }))
                    .foregroundColor(.secondary)
                    .font(.body)
            )
    }
}


enum MultiPickerButtonError: Error
{
    case pickerCountOutOfRange
}


struct MultiPickerButtonSelectionParams
{
    let pickerCount: Int
    let selections: [any MultiPickerSelectable]
    let selectionTitle: String
    var selectedIndexes: [Int]?
}


struct MultiPickerButton: View {
    @State private var showPickerSheet = false
    
    private let params: MultiPickerButtonSelectionParams
    @State private var selectedIndexes: [Int]
    @State private var selecteds: [any MultiPickerSelectable]
    
    private let customDisplayer: MultiPickerButtonCustomDisplayer?
    private var itemSelected: ((_ selecteds: [any MultiPickerSelectable]) -> Void)?
    
    init(params: MultiPickerButtonSelectionParams,
         displayer: MultiPickerButtonCustomDisplayer? = nil,
         itemSelected: @escaping ((_ selecteds: [any MultiPickerSelectable]) -> Void)) throws {

        if params.pickerCount <= 0 || params.pickerCount > 3
        {
            throw MultiPickerButtonError.pickerCountOutOfRange
        }
        
        self.params = params
        self.customDisplayer = displayer
        self.itemSelected = itemSelected
        
        
        var indexes = [Int]()
        var parent: (any MultiPickerSelectable)?
        var selecteds = [any MultiPickerSelectable]()
        for i in 0 ..< self.params.pickerCount
        {
            var index = 0
            if let indexes = self.params.selectedIndexes, indexes.count > i
            {
                index = indexes[i]
            }
            
            indexes.append(index)
            
            if index >= 0
            {
                if i == 0
                {
                    if index < self.params.selections.count
                    {
                        let selected = self.params.selections[index]
                        selecteds.append(selected)
                        parent = selected
                    }
                }
                else if let subs = parent?.subs, subs.count > index
                {
                    let selected = subs[index]
                    selecteds.append(selected)
                    parent = selected
                }
            }
        }
        
        _selectedIndexes = State(initialValue: indexes)
        
        _selecteds = State(initialValue: selecteds)
    }
    
    var body: some View {
        Button(action: {
            showPickerSheet.toggle()
        }) {
            if let view = self.customDisplayer?.getButtonView(selecteds: self.selecteds)
            {
                view
            }
            else
            {
                let title = self.shownTitle
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
        }
        .sheet(isPresented: $showPickerSheet) {
            DynamicBottomSheetViewContainer(
             content: {
                 MultiPickerSheetView(
                    pickerCount: self.params.pickerCount,
                    selections: self.params.selections,
                    selectedIndexes: self.selectedIndexes,
                    selectionTitle: self.params.selectionTitle,
                    displayer: self.customDisplayer) {
                        selecteds in
                        var new_selecteds = [any MultiPickerSelectable]()
                        
                        for (i, selected) in selecteds.enumerated() {
                            self.selectedIndexes[i] = selected.index
                            new_selecteds.append(selected.selected)
                        }
                        
                        self.selecteds = new_selecteds
                    }
             },
             dragIndicatorStyle: BottomSheetViewDragIndicatorStyle.hidden,
             interactiveDismiss: false)
           }
    }
    
    private var shownTitle: String
    {
        var title = "-----------"
        
        for (i, selectedIndex) in selectedIndexes.enumerated() {
            let selections = getSelections(i)
            if selectedIndex >= 0 && selectedIndex < selections.count
            {
                if i == 0
                {
                    title = ""
                }
                
                if title.count > 0
                {
                    title += " - "
                }
                
                title += selections[selectedIndex].name
            }
        }
        
        return title
    }

    private func getSelections(_ pickerIndex: Int) -> [any MultiPickerSelectable]
    {
        if pickerIndex == 0
        {
            return self.params.selections
        }
        
        
        var parent: (any MultiPickerSelectable)?
        for i in 0 ... pickerIndex
        {
            let selectedIndex = self.selectedIndexes[i]
            
            if i == 0
            {
                if selectedIndex >= 0 && self.params.selections.count > selectedIndex
                {
                    parent = self.params.selections[selectedIndex]
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
