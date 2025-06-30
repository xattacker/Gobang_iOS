//
//  UILineView.swift
//  Test1
//
//  Created by xattacker.tao on 2021/6/25.
//  Copyright © 2021 Xattacker. All rights reserved.
//

import UIKit
import SwiftUI


@IBDesignable public class UILineView: UIView
{
    public enum LineStyle
    {
        case dotted
        case solid
    }

    public enum LineOrientation
    {
        case vertical
        case horizontal
    }

    public var lineStyle: LineStyle = .dotted
    public var orientation: LineOrientation = .vertical
    
    @IBInspectable public var lineColor: UIColor = .gray
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var lineWidthRatio: CGFloat = 0.25
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        let path = UIBezierPath()
        
        switch self.orientation
        {
            case .vertical:
                path.move(to: CGPoint(x: rect.width/2, y: 0))
                path.addLine(to: CGPoint(x: rect.width/2, y: rect.height))
                break
                
            case .horizontal:
                path.move(to: CGPoint(x: 0, y: rect.height/2))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
                break
        }
        
        if self.lineStyle == .dotted
        {
            let params: [CGFloat] = [1,5]
            path.setLineDash(params, count: params.count, phase: 0)
        }

        path.close()

        self.lineColor.set()
        path.lineCapStyle = .round
        path.lineWidth = 2
        path.stroke()
    }
}


public struct LineView: UIViewRepresentable
{
    public typealias UIViewType = UILineView
    
    private let lineView = UILineView(frame: CGRect.zero)
    
    public func lineColor(_ color: Color) -> LineView
    {
        self.lineView.lineColor = UIColor(color)
        return self
    }
    
    public func orientation(_ orientation: UILineView.LineOrientation) -> LineView
    {
        self.lineView.orientation = orientation
        return self
    }
    
    public func makeUIView(context: Context) -> UILineView
    {
        return self.lineView
    }
    
    public func updateUIView(_ uiView: UILineView, context: Context)
    {
    }
}
