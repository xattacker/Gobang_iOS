//
//  MyWebView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2025/6/3.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import SwiftUI
import WebKit


struct MyWebView: View, CustomNavigationDisplayer
{
    @State private var isLoading = false
    
    var navigationTitle: String
    {
        return "WebView"
    }
    
    var navigationRightItems: [CustomNavigationItem]?
    {
        return [
            CustomNavigationItem(style: .title(title: "action", color: .blue), action: {
                print("action1")
            }),
            CustomNavigationItem(style: .image(image: Image("ic_carinfo_person")), action: {
                print("action2")
            })
        ]
    }
    
    var body: some View {
        CustomViewContainer(
            content: {
                ZStack {
                    WebView(url: URL(string: "https://www.apple.com.tw")!,
                            isLoading: $isLoading)
                    if self.isLoading
                    {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }
            },
            navigationDisplayer: self)
    }
}


struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
