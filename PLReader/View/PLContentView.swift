//
//  PLContentView.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit
import CoreText

class PLContentView: UIView {

    var frameRef: CTFrame?
    
    func showFrame(frame: CTFrame,bgColor color: UIColor) {
        frameRef = frame
        backgroundColor = color
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        if frameRef == nil || backgroundColor == nil || context == nil {
            return
        }
        
        context.setFillColor(backgroundColor!.cgColor)
        context.fill(rect)
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.textMatrix = CGAffineTransform.identity
        
        CTFrameDraw(frameRef!, context)
    }
}
