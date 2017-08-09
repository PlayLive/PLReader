//
//  PLTextHandleManager.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

class PLTextHandleManager: NSObject {
    
    static func refreshGroupModel(groupModel: PLChapterGroupModel, configModel: PLTextConfigModel){
    
        groupModel.refersh()
        
        for itemModel: PLChapterModel in groupModel.itemModels {
            PLTextHandleManager.handleChapterModel(chapterModel: itemModel, configModel: configModel)
        }
        
    }
    
    static func handleText(text: String, configModel: PLTextConfigModel) -> PLChapterModel {
        let chapterModel: PLChapterModel = PLChapterModel(ID: "")
        chapterModel.text = text
        PLTextHandleManager.handleChapterModel(chapterModel: chapterModel, configModel: configModel)
        
        return chapterModel
    }
    
    
    private static func handleChapterModel(chapterModel: PLChapterModel, configModel: PLTextConfigModel){
        
        let attributes = configModel.refAttributes
        let attributesStr = NSMutableAttributedString(string: chapterModel.text, attributes: attributes)
        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributesStr)
        
        PLTextHandleManager.handleChapterPageModel(chapterModel: chapterModel, framesetter: framesetter, startIndex: 0, rect: configModel.contextRect)
        
    }
    
    private static func handleChapterPageModel(chapterModel: PLChapterModel, framesetter: CTFramesetter, startIndex: CFIndex, rect: CGRect){
        let path: CGPath = CGPath.init(rect: rect, transform: nil)
        let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRange.init(location: startIndex, length: 0), path, nil)
        let range: CFRange = CTFrameGetVisibleStringRange(frame)
        if(range.length > 0){
            let pageModel: PLChapterPageModel = PLChapterPageModel()
            pageModel.startIndex = startIndex
            pageModel.length = range.length
            pageModel.frameRef = frame
            
            chapterModel .addPageModel(model: pageModel)
            
            PLTextHandleManager.handleChapterPageModel(chapterModel: chapterModel, framesetter: framesetter, startIndex: startIndex + range.length, rect: rect)
        }
    }
}
