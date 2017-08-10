//
//  PLTextConfigModel.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit
import CoreText

class PLTextConfigModel: NSObject {
    
    private let instance: PLTextConfigModel = PLTextConfigModel()
    
    class var shared: PLTextConfigModel {
        return instance
    }
    
    let TextConfigBgColors: [UIColor] = [
        UIColor.init(red: 255/255.0, green: 214/255.0, blue: 196/255.0, alpha: 1),
        UIColor.init(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1),
        UIColor.init(red: 57/255.0, green: 51/255.0, blue: 53/255.0, alpha: 1),
        UIColor.init(red: 204/255.0, green: 233/255.0, blue: 206/255.0, alpha: 1)
    ]
    
    let TextConfigFontColors: [UIColor] = [
        UIColor.init(red: 58/255.0, green: 51/255.0, blue: 66/255.0, alpha: 1),
        UIColor.init(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1),
        UIColor.init(red: 149/255.0, green: 147/255.0, blue: 143/255.0, alpha: 1),
        UIColor.init(red: 149/255.0, green: 147/255.0, blue: 143/255.0, alpha: 1)
    ]
    
    var fontSize: Float = 14
    var fontName: String = "微软雅黑"
    var bgColorIndex: Int = 0
    var isNight: Bool = false
    var contextRect: CGRect = CGRect.init()
    
    var backgroundColor: UIColor {
        get {
            if isNight {
                return UIColor.black
            }
            return rawBackgroundColor
        }
    }
    var rawBackgroundColor: UIColor {
        get {
            return TextConfigBgColors[bgColorIndex]
        }
    }
    var fontColor: UIColor {
        get {
            if isNight {
                return UIColor.init(white: 1, alpha: 0.7)
            }
            return TextConfigFontColors[bgColorIndex]
        }
    }
    
    
    var refAttributes: Dictionary<String, AnyObject> {
        get {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = CGFloat(fontSize * 2)
            paragraphStyle.lineSpacing = 5.0
            
            let font: UIFont = UIFont.systemFont(ofSize:CGFloat(fontSize))
            
            return [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : fontColor,
                NSParagraphStyleAttributeName : paragraphStyle
            ]
        }
    }
}
