//
//  PLChapterModel.swift
//  PLReader
//
//  Created by xiong on 2017/8/7.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit
import CoreText

class PLChapterPageModel: NSObject {
    
    var frameRef: CTFrame?
    var startIndex: CFIndex = 0
    var length: CFIndex = 0
    
    func destroy() {
        frameRef = nil
    }
}

class PLChapterModel: NSObject {
    var chapterID: String = ""
    var prevChapterID: String = ""
    var nextChapterID: String = ""
    var text: String = ""
    var itemModels: [PLChapterPageModel]?
    
    
    var itemCount: UInt {
        get {
            if let models = itemModels {
                return UInt(models.count)
            }
            return 0
        }
    }
    
    var maxPageIndex: UInt {
        if itemCount > 0 {
            return itemCount - 1
        }
        return 0
    }
    
    init(ID: String) {
        chapterID = ID
        itemModels = [PLChapterPageModel]()
    }

    
    func addPageModel(model: PLChapterPageModel){
        itemModels?.append(model)
    }
    
    func getItemModelByIndex(index: Int) -> PLChapterPageModel? {
        var pageModel: PLChapterPageModel?
        if index >= 0 && index < Int(itemCount) {
            pageModel =  itemModels?[index]
        }
        return pageModel
    }
    
    func onlyHaveOnePage() -> Bool {
        return itemCount == 1
    }
    
    func havePage() -> Bool {
        return itemCount > 0
    }
    
    func clearItems() {
        if let models = itemModels {
            for item:PLChapterPageModel in models{
                item.destroy()
            }
            itemModels?.removeAll()
        }

    }
    
    func canPrev() -> Bool {
        
        return !(prevChapterID == chapterID)
    }
    
    func canNext() -> Bool{
        
        return !(nextChapterID == chapterID)
    }
    
    func destroy() {
        clearItems()
        itemModels = nil
        text = ""
    }
    
    

}
