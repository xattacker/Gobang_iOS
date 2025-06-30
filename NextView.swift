//
//  NextView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/11/29.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI


struct NextView: View, CustomNavigationDisplayer {
    private let item: ListItem
    @State private var showBottomSheet = false
    
    @State private var alertHandler = AlertHandleModifier()
    
    private var multiItems = [MultiPickerItem]()
        
    init(item: ListItem) {
        self.item = item
        
        var subItems1 = [MultiPickerItem]()
        for i in 0 ..< 3
        {
            var subItem = MultiPickerItem(id: String(i+1), name: String(format: "aa%d", i+1))
       
            var subItemSub = [MultiPickerItem]()
            for j in 0 ..< 3
            {
                subItemSub.append(MultiPickerItem(id: String(j+1), name: String(format: "%@_%d", subItem.name, j+1)))
            }
            
            subItem.subs = subItemSub
            
            subItems1.append(subItem)
        }
        
        var item1 = MultiPickerItem(id: "", name: "a")
        item1.subs = subItems1
        self.multiItems.append(item1)
        
        
        var subItems2 = [MultiPickerItem]()
        for i in 0 ..< 5
        {
            var subItem = MultiPickerItem(id: String(i+1), name: String(format: "bb%d", i+1))
       
            var subItemSub = [MultiPickerItem]()
            for j in 0 ..< 2
            {
                subItemSub.append(MultiPickerItem(id: String(j+1), name: String(format: "%@_%d", subItem.name, j+1)))
            }
            
            subItem.subs = subItemSub
            
            subItems2.append(subItem)
        }
        
        var item2 = MultiPickerItem(id: "", name: "b")
        item2.subs = subItems2
        self.multiItems.append(item2)
        
        
        var subItems3 = [MultiPickerItem]()
        for i in 0 ..< 1
        {
            subItems3.append(MultiPickerItem(id: String(i+1), name: String(format: "c%d", i+1)))
        }
        
        var item3 = MultiPickerItem(id: "", name: "c")
        item3.subs = subItems3
        self.multiItems.append(item3)
    }
    
    var navigationTitle: String
    {
        return self.item.title ?? ""
    }
    
    var body: some View {
        CustomViewContainer(
            content: {
                VStack(spacing: 20) {
                    NavigationLink(destination: NextView2(item: item)) {
                        Text("Next")
                            .foregroundColor(.green)
                    }
                    NavigationLink(destination: MyMapView()) {
                        Text("MapView")
                            .foregroundColor(.green)
                    }
                    NavigationLink(destination: MyWebView()) {
                        Text("WebView")
                            .foregroundColor(.green)
                    }
                    Button("Show Alert") {
                        alertHandler.showAlert(
                            "Alert Title",
                            message: "Content",
                            buttons: [
                                // OK Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "OK",
                                      role: nil,
                                      action: {
                                }),
                                // NO Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "NO",
                                      role: .destructive,
                                      action: {
                                }),
                                // Cancel Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "Cancel",
                                      role: .cancel,
                                      action: {
                                })])
                    }
                    Button("Show BottomSheet Alert") {
                        alertHandler.showBottomSheetAlert(
                            "BottomSheet Title",
                            buttons: [
                                // OK Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "OK",
                                      role: nil,
                                      action: {
                                }),
                                // NO Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "NO",
                                      role: .destructive,
                                      action: {
                                }),
                                // Cancel Button
                                AlertHandleModifier.ButtonInfo(
                                    title: "Cancel",
                                      role: .cancel,
                                      action: {
                                })])
                    }
                    Button("Show My Bottom Sheet") {
                        showBottomSheet.toggle()
                    }
                    .sheet(isPresented: $showBottomSheet) {
                        DynamicBottomSheetViewContainer(
                         content: {
                            MyBottomSheetView()
                         })
                       }
                    DatePickerButton(
                        params: DatePickerButtonParams(
                                    mode: .dateTime,
                                    customDisplayer: nil),
                        selectionTitle: "選擇日期",
                        timeSelected: {
                        selectedDate in
                        print(selectedDate.description)
                    })
                    PickerButton(params: PickerButtonSelectionParams(
                                            selections: [PickerSelectionItem(name: "aaa"),
                                                        PickerSelectionItem(name: "bbb"),
                                                        PickerSelectionItem(name: "ccc"),
                                                        PickerSelectionItem(name: "xxx"),
                                                        PickerSelectionItem(name: "yyy"),
                                                        PickerSelectionItem(name: "zzz")],
                                            selectionTitle:  "請選擇項目",
                                            selectedIndex: 1),
                                 displayer: MyPickerButtonCustomDisplayer()) {
                        item, index in
                        print("PickerButton selected: \(item.name)")
                    }
                    try? MultiPickerButton(
                            params: MultiPickerButtonSelectionParams(
                                        pickerCount: 3,
                                        selections: multiItems,
                                        selectionTitle: "請選擇項目",
                                        selectedIndexes: [1, 2]),
                            displayer: MyMultiPickerButtonCustomDisplayer(),
                            itemSelected: {
                                selecteds in
                                print("MultiPickerButton selected)")
                            })
                    LineView()
                        .lineColor(Color.yellow)
                        .orientation(.horizontal)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 20)
                }.padding()
                .modifier(alertHandler)
            },
            navigationDisplayer: self)
    }
}


final class MyDatePickerButtonCustomDisplayer: DatePickerButtonCustomDisplayer
{
    func getButtonView(date: Date, mode: DatePickerButtonMode) -> AnyView?
    {
        AnyView(
                Text(self.dateString(date))
                    .foregroundColor(.red)
                )
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let locale = Locale(identifier: "en_US")
        formatter.locale = locale
        
        return formatter.string(from: date)
    }
}


final class MyPickerButtonCustomDisplayer: PickerButtonCustomDisplayer
{
    func getButtonView(title: String) -> AnyView?
    {
        AnyView(
                Text(title)
                    .foregroundColor(.black)
                )
    }
    
    func getPickerItemView(item: PickerSelectionItem, index: Int) -> AnyView?
    {
        return AnyView(
                Label(item.name, systemImage: "star.fill")
                    .foregroundColor(index % 2 == 0 ? .blue : .green)
                )
    }
}


final class MyMultiPickerButtonCustomDisplayer: MultiPickerButtonCustomDisplayer
{
    func getButtonView(selecteds: [any MultiPickerSelectable]) -> AnyView?
    {
        return AnyView(
                    HStack(spacing: 4, content: {
                        ForEach(0 ..< selecteds.count, id: \.self) {
                            index in
                            Text(selecteds[index].name)
                            .foregroundColor(.indigo)
                            .font(.body)
                            if index < selecteds.count - 1
                            {
                                Text("-")
                                .foregroundColor(.lightGray)
                                .font(.body)
                            }
                        }
                    })
                )
    }
    
    func getPickerItemView(item: any MultiPickerSelectable, itemIndex: Int, pickerIndex: Int) -> AnyView?
    {
        return AnyView(
                Label(item.name, systemImage: "star.fill")
                    .foregroundColor(itemIndex % 2 == 0 ? .blue : .green)
                )
    }
}
