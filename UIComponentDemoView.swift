//
//  UIComponentDemoView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/1/16.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


struct UIComponentDemoView: View, CustomNavigationDisplayer {
    @State private var toggleState = false
    @State private var sliderValue: Double = 50
    @State private var stepperValue = 0
    @State private var segmentedPickerSelection = 0
    @State private var wheelPickerSelection = 0
    @State private var menuPickerSelection = 0
    @State private var naviLinkPickerSelection = 0
    @State private var date = Date()
    @State private var textFieldValue = ""
    
    var navigationTitle: String
    {
        return "UIComponent"
    }

    var body: some View {
        CustomViewContainer(
            content: {
                ScrollView {
                    VStack(spacing: 20) {
                        // Text
                        Text("這是一段文字")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        // Button
                        Button(action: {
                            print("按鈕被點擊")
                        }) {
                            Text("點擊我")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Image
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                        
                        // TextField
                        TextField("輸入內容", text: $textFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        // Toggle
                        Toggle("開關狀態", isOn: $toggleState)
                            .toggleStyle(SwitchToggleStyle(tint: .purple))
                        
                        // Slider
                        VStack {
                            Text("Slider 值: \(Int(sliderValue))")
                            Slider(value: $sliderValue, in: 0...100)
                                .accentColor(.orange)
                        }
                        
                        // Stepper
                        Stepper("Stepper 值: \(stepperValue)", value: $stepperValue)
                        
                        // SegmentedPicker
                        Picker("選擇顏色", selection: $segmentedPickerSelection) {
                            Text("紅色").tag(0)
                            Text("綠色").tag(1)
                            Text("藍色").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        // Wheel Picker
                        Picker("選擇顏色", selection: $wheelPickerSelection) {
                            Text("紅色").tag(0)
                            Text("綠色").tag(1)
                            Text("藍色").tag(2)
                        }
                        .pickerStyle(.wheel)
                        
                        // Menu Picker
                        Picker("请选择", selection: $menuPickerSelection) {
                            Text("苹果").tag(0)
                            Text("香蕉").tag(1)
                        }
                        .pickerStyle(.menu)

                        if #available(iOS 16, *)
                        {
                            // NavigationLink Picker
                            Picker("请选择", selection: $naviLinkPickerSelection) {
                                Text("苹果").tag(0)
                                Text("香蕉").tag(1)
                            }
                            .pickerStyle(.navigationLink)
                        }
                        
                        // DatePicker
                        DatePicker("選擇日期", selection: $date, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                        
                        // ProgressView
                        ProgressView("載入中...", value: sliderValue, total: 100)
                    }
                    .padding()
                }
            },
            navigationDisplayer: self)
    }
}
