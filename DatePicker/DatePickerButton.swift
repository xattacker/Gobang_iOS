//
//  DatePickerButton.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/1/16.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI


protocol DatePickerButtonCustomDisplayer: AnyObject
{
    func getButtonView(date: Date, mode: DatePickerButtonMode) -> AnyView?
}


enum DatePickerButtonMode
{
    case date
    case time
    case dateTime
    
    var components: DatePicker.Components
    {
        switch self {
            case .date:
                return .date
            
            case .time:
                return .hourAndMinute
            case .dateTime:
            
                return [.date, .hourAndMinute]
        }
    }
}

struct DatePickerButtonParams
{
    let mode: DatePickerButtonMode
    var dateFormat: String?
    var customDisplayer: DatePickerButtonCustomDisplayer?
}


struct DatePickerButton: View {
    @State private var showDatePickerSheet = false
    @State private(set) var date: Date
    
    private let dateParams: DatePickerButtonParams
    private let dateFormat: String
    private let selectionTitle: String
    private var timeSelected: ((_ selectedDate: Date) -> Void)?
    
    init(date: Date? = nil,
         params: DatePickerButtonParams = DatePickerButtonParams(mode: .date),
         selectionTitle: String,
         timeSelected: @escaping ((_ selectedDate: Date) -> Void)) {
        self.date = date ?? Date()
        self.dateParams = params
        
        if let format = params.dateFormat, format.count > 0
        {
            self.dateFormat = format
        }
        else
        {
            switch params.mode
            {
                case .date:
                    self.dateFormat = "yyyy-MM-dd"
                    break
                    
                case .time:
                    self.dateFormat = "HH:mm"
                    break
                
                case .dateTime:
                    self.dateFormat = "yyyy-MM-dd HH:mm"
                    break
            }
        }
        
        self.selectionTitle = selectionTitle
        self.timeSelected = timeSelected
    }
    
    var body: some View {
        Button(action: {
            showDatePickerSheet.toggle()
        }) {
            if let view = self.dateParams.customDisplayer?.getButtonView(date: self.date, mode: self.dateParams.mode)
            {
                view
            }
            else
            {
                Text(self.dateString)
                    .foregroundColor(.black)
                    .font(.body)
            }
        }
        .sheet(isPresented: $showDatePickerSheet) {
            DynamicBottomSheetViewContainer(
             content: {
                 DatePickerSheetView(
                    date: self.date,
                    dateComponents: self.dateParams.mode.components,
                    selectionTitle: self.selectionTitle) {
                     date in
                     self.date = date
                     timeSelected?(date)
                 }
             },
             dragIndicatorStyle: BottomSheetViewDragIndicatorStyle.hidden,
             interactiveDismiss: false)
           }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat
        
        let locale = Locale(identifier: "en_US")
        formatter.locale = locale
        
        return formatter.string(from: self.date)
    }
}
