//
//  CustomViewContainer.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/12/2.
//  Copyright © 2024 TCCI MACKBOOK PRO. All rights reserved.
//

import SwiftUI


@MainActor
protocol CustomNavigationDisplayer
{
    var navigationTitle: String { get }
    var navigationTitleColor: Color { get }
    
    var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode { get }
    
    var navigationBarColor: Color { get }
    
    var showNavigationBar: Bool { get }
    var showNavigationBack: Bool { get }
    
    var navigationRightItems: [CustomNavigationItem]?  { get }
}

enum CustomNavigationItemStyle
{
    case title(title: String, color: Color)
    case image(image: Image)
}

struct CustomNavigationItem: Identifiable
{
    let id = UUID()
    
    let style: CustomNavigationItemStyle
    let action: (() -> Void)
}

extension CustomNavigationDisplayer
{
    var navigationTitle: String
    {
        return ""
    }
    
    var navigationTitleColor: Color
    {
        return .blue
    }
    
    var navigationTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    {
        return .inline
    }
    
    var navigationBarColor: Color
    {
        return .white
    }
    
    var showNavigationBar: Bool
    {
        return true
    }
    
    var showNavigationBack: Bool
    {
        return true
    }
    
    var navigationRightItems: [CustomNavigationItem]?
    {
        return nil
    }
}


struct CustomViewContainer<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode
    
    private let content: Content
    private let navigationDisplayer: CustomNavigationDisplayer

    init(@ViewBuilder content: () -> Content, navigationDisplayer: CustomNavigationDisplayer) {
        self.content = content()
        self.navigationDisplayer = navigationDisplayer
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.white
            content
            .navigationTitle(self.navigationDisplayer.navigationTitle)
            .navigationBarHidden(!self.navigationDisplayer.showNavigationBar)
            .navigationBarTitleDisplayMode(self.navigationDisplayer.navigationTitleDisplayMode)
            .navigationBarBackButtonHidden()
//            .modifier(CustomNavigationBarModifier(
//                        navigationDisplayer: self.navigationDisplayer,
//                        backAction: {
//                            presentationMode.wrappedValue.dismiss()
//                        }))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    if self.navigationDisplayer.showNavigationBack
                    {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("ic_nav_back_black")
                        })
                    }
                }
                
//                // 自定義 Navigation Title => 這樣設定 無法對 large title 有效果
//                ToolbarItem(placement: .principal) {
//                    Text(self.navigationDisplayer.navigationTitle)
//                        .font(.title3)
//                        .foregroundColor(self.navigationDisplayer.navigationTitleColor)
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let rightItems = self.navigationDisplayer.navigationRightItems
                    {
                        HStack {
                            ForEach(rightItems) {
                                item in
                                switch item.style
                                {
                                    case .title(let title, let color):
                                        Button(action: {
                                            item.action()
                                        }) {
                                            Text(title)
                                                .foregroundColor(color)
                                                .font(.body)
                                        }
   
                                    case .image(let img):
                                        Button(action: {
                                            item.action()
                                        }) {
                                            img
                                        }
                                }
                            }
                        }
                    }
                }
            })
        }
        .onAppear {
          //  UINavigationBar.appearance().prefersLargeTitles = self.navigationDisplayer.navigationTitleDisplayMode == .large
            
//            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = UIColor(self.navigationDisplayer.navigationBarColor)
//            appearance.titleTextAttributes = [.foregroundColor: UIColor(self.navigationDisplayer.navigationTitleColor)]
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(self.navigationDisplayer.navigationTitleColor)]
//
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
//        .onDisappear {
//            UINavigationBar.appearance().prefersLargeTitles = false
//        }
    }
}

fileprivate struct CustomNavigationBarModifier: ViewModifier {
    private let navigationDisplayer: CustomNavigationDisplayer
    private let backAction: (() -> Void)?
    
    init(navigationDisplayer: CustomNavigationDisplayer, backAction: @escaping (() -> Void))
    {
        self.navigationDisplayer = navigationDisplayer
        self.backAction = backAction
    }
    
    func body(content: Content) -> some View {
        content.toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                if self.navigationDisplayer.showNavigationBack
                {
                    Button(action: {
                        self.backAction?()
                    }, label: {
                        Image("ic_nav_back_black")
                    })
                }
            }
            
//                // 自定義 Navigation Title => 這樣設定 無法對 large title 有效果
//                ToolbarItem(placement: .principal) {
//                    Text(self.navigationDisplayer.navigationTitle)
//                        .font(.title3)
//                        .foregroundColor(self.navigationDisplayer.navigationTitleColor)
//                }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if let rightItems = self.navigationDisplayer.navigationRightItems
                {
                    HStack {
                        ForEach(rightItems) {
                            item in
                            Button(action: {
                                item.action()
                            }) {
                                switch item.style
                                {
                                    case .title(let title, let color):
                                        Button(action: {
                                            item.action()
                                        }) {
                                            Text(title)
                                                .foregroundColor(color)
                                                .font(.body)
                                        }

                                    case .image(let img):
                                        Button(action: {
                                            item.action()
                                        }) {
                                            img
                                        }
                                }
                            }
                        }
                    }
                }
            }
        })
        
        if #available(iOS 16, *)
        {
            content.toolbarBackground(self.navigationDisplayer.navigationBarColor, for: .navigationBar)
        }
        
        if #available(iOS 18, *)
        {
            content.toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
