//
//  PLChapterGroupModel.swift
//  PLReader
//
//  Created by xiong on 2017/8/7.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

class PLChapterGroupModel: NSObject {
    var currentChapterID: String!
    var currentPageIndex: UInt = 0
    var itemModels: [PLChapterModel]
    
    
    override init() {
        currentChapterID = ""
        currentPageIndex = 0
        itemModels = [PLChapterModel]()
    }
    
    var chapterCount: UInt {
        get {
            return UInt(itemModels.count)
        }
    }
    
    var maxPageIndex: UInt {
        get {
            let chapterModel = currentChapter()
            if chapterModel != nil {
                return chapterModel!.maxPageIndex
            }
            return 0
        }
    }
    
    //MARK: - 章节的增、删处理
    
    func addFirstChapter(model: PLChapterModel) {
        clearItems()
        itemModels.append(model)
        currentPageIndex = 0
        currentChapterID = model.chapterID
    }
    
    
    func addPrevChapter(model: PLChapterModel, currentChapterID chapterID: String) {
        guard chapterCount > 0 else {
            itemModels.append(model)
            return
        }
        removeChapterByID(chapterID: model.chapterID)
        let index: Int = getChapterModelIndexByID(chapterID: chapterID)
        
        if index >= 0 {
            itemModels.insert(model, at: index)
        } else {
            itemModels.append(model)
        }
    }
    
    func addNextChapter(model: PLChapterModel, currentChapterID chapterID: String) {
        if chapterCount == 0 {
            itemModels.append(model)
            return
        }
        
        removeChapterByID(chapterID: model.chapterID)
        
        let index: Int = getChapterModelIndexByID(chapterID: chapterID)
        if index >= 0 && index < Int(chapterCount) - 1 {
            itemModels.insert(model, at: index+1)
        } else {
            itemModels.append(model)
        }
        
    }

    
    //MARK: - 章节的更新
    
    func removeChapterByID(chapterID: String) {
        guard !itemModels.isEmpty else {
            return
        }

        let searchIndex: Int = getChapterModelIndexByID(chapterID: chapterID)
        if searchIndex > -1 {
            itemModels.remove(at:searchIndex)
        }
        
        
    }
    
    //MARK: - 章节切换相关处理

    func canMovePrev() -> Bool {
        if canMoveCurrentPrev() {
            return true
        }
        
        if canMoveToPrevChapter() {
            return true
        }
        
        return false
    }
    
    func canMoveCurrentPrev() -> Bool {
        return currentPageIndex > 0
    }
    
    func canMoveToPrevChapter() -> Bool {
        let prevModel = prevChapter()
        if currentPageIndex == 0 && prevModel != nil  && prevModel!.havePage() {
            return true
        }
        return false
    }
    
    func canMoveNext() -> Bool {
        if canMoveCurrentChapterNext() {
            return true;
        }
        
        if canMoveToNextChapter() {
            return true;
        }
        return false
    }
    
    func canMoveCurrentChapterNext() -> Bool {
        
        let chapterModel: PLChapterModel? = currentChapter()
        
        if chapterModel != nil && currentPageIndex < chapterModel!.maxPageIndex {
            return true
        }

        return false
    }
    
    func canMoveToNextChapter() -> Bool {
        let chapterModel: PLChapterModel? = currentChapter()
        let nextChapterModel: PLChapterModel? = nextChapter()
        
        guard chapterModel == nil || nextChapterModel == nil else {
            return currentPageIndex == chapterModel!.maxPageIndex && nextChapterModel!.havePage()
        }
        return false;
    }
    
    
    func moveNext() {
        if canMoveCurrentChapterNext() {
            currentPageIndex += 1
            return
        }
        
        if canMoveToNextChapter() {
            currentChapterID = currentChapter()?.nextChapterID
            currentPageIndex = 0
        }
    }
    
    func movePrev() {
        if canMoveCurrentPrev() {
            currentPageIndex -= 1
            return
        }
        
        if canMoveToPrevChapter() {
            let prevChapterModel: PLChapterModel? = prevChapter()
            currentPageIndex = prevChapterModel!.maxPageIndex
            currentChapterID = prevChapterModel!.chapterID
        }
    }
    
    //MARK: - 获取章节数据
    
    func getChapterModelByID(chapterID: String) -> PLChapterModel? {
        for item in itemModels {
            if item.chapterID == chapterID {
                return item
            }
        }
        
        return nil
    }
    
    func getChapterModelIndexByID(chapterID: String) -> Int {
        for (index, item) in itemModels.enumerated() {
            if item.chapterID == chapterID {
                return index
            }
        }
        return -1
    }
    
    func prevChapter() -> PLChapterModel? {
        let chapterModel: PLChapterModel? = currentChapter()
        
        if chapterModel != nil && chapterModel!.canPrev() {
            return getChapterModelByID(chapterID: chapterModel!.prevChapterID)
        }
        
        return nil
    }
    
    func currentChapter() -> PLChapterModel? {
        return getChapterModelByID(chapterID: currentChapterID!)
    }
    
    func nextChapter() -> PLChapterModel? {
        let chapterModel: PLChapterModel? = currentChapter()
        
        if chapterModel != nil && chapterModel!.canNext() {
            return getChapterModelByID(chapterID: chapterModel!.nextChapterID)
        }
        
        return nil
    }
    
    func haveChapter(chapterID: String) -> Bool {
        for chapterModel in itemModels {
            if chapterModel.chapterID == chapterID {
                return true
            }
        }
        return false
    }
    
    //MARK: - 章节的页相关的处理
    
    func getPageModelByChapterID(chapterID: String, pageIndex: Int) -> PLChapterPageModel? {
        let chapterModel: PLChapterModel? = getChapterModelByID(chapterID: chapterID)
        if chapterModel != nil {
            return chapterModel!.getItemModelByIndex(index: pageIndex)
        }
        
        return nil
    }
    
    func prevPageModel() -> PLChapterPageModel? {
        if canMoveCurrentPrev() {
            return getPageModelByChapterID(chapterID: currentChapterID!, pageIndex: Int(currentPageIndex) - 1)
        }
        
        if canMoveToPrevChapter() {
            let chapterModel = prevChapter()
            return chapterModel!.getItemModelByIndex(index: Int(chapterModel!.maxPageIndex))
        }

        return nil
    }
    
    func currentPageModel() -> PLChapterPageModel? {
        return getPageModelByChapterID(chapterID: currentChapterID!, pageIndex: Int(currentPageIndex))
    }
    
    func nextPageModel() -> PLChapterPageModel? {
        if canMoveCurrentChapterNext() {
            return getPageModelByChapterID(chapterID: currentChapterID!, pageIndex: Int(currentPageIndex) + 1)
        }
        
        if canMoveToNextChapter() {
            let chapterModel = nextChapter()
            return chapterModel!.getItemModelByIndex(index: 0)
        }
        
        return nil
    }
    
    
    func clearItems() {
        currentPageIndex = 0
        currentChapterID = nil
        
        for itemModel: PLChapterModel in itemModels {
            itemModel.destroy()
        }
        
        itemModels.removeAll()
    }
    
    func refersh() {
        currentPageIndex = 0
        
        for itemModel: PLChapterModel in itemModels {
            itemModel.clearItems()
        }
    }
    
    
    
}
