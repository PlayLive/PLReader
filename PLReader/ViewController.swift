//
//  ViewController.swift
//  PLReader
//
//  Created by xiong on 2017/8/7.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

class ViewController: PLReaderViewController {
    
    let ChapterID_One: String = "Chapter1"
    let ChapterID_Two: String = "Chapter2"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //view.backgroundColor = UIColor.black
        
        addChapter(resourcesName: ChapterID_One, resourcesChapterID: ChapterID_One, currentChapterID: ChapterID_One, prevChapterID: ChapterID_One, nextChapterID: ChapterID_Two, postionType: ChapterPostionType.current)
        
        addChapter(resourcesName: ChapterID_Two, resourcesChapterID: ChapterID_Two, currentChapterID: ChapterID_One, prevChapterID: ChapterID_One, nextChapterID: ChapterID_Two, postionType: ChapterPostionType.next)
        
        self.show()
    }
    
    override func initCustomView() {
        PLTextConfigModel.share.contextRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40)
    }
    
    func addChapter(resourcesName: String, resourcesChapterID: String, currentChapterID: String, prevChapterID: String, nextChapterID: String, postionType: ChapterPostionType) {
        let text: String? = try? String(contentsOfFile: Bundle.main.path(forResource: resourcesName, ofType: "txt")!, encoding: String.Encoding.utf8)
        if text != nil {
            let chapterModel = addChapter(text: text!, chapterID: resourcesChapterID, currentChapterID: currentChapterID, type: postionType)
            chapterModel?.prevChapterID = prevChapterID
            chapterModel?.nextChapterID = nextChapterID
        }
    }
    
    override func requestNext(chapterID: String) {
        let chapterModel: PLChapterModel? = chapterGroupModel?.getChapterModelByID(chapterID: chapterID)
        
        if chapterModel == nil || chapterModel?.canNext() == false || chapterGroupModel?.haveChapter(chapterID: chapterModel!.nextChapterID) == true {
            return;
        }
        //请求下一章的数据，得到数据后加入数据集
        //addChapter(text: nextText, chapterID: nextChapterID, currentChapterID: chapterModel.chapterID, type: ChapterPostionType.next)
        
        
        
    }
    
    override func requestPrev(chapterID: String) {
        let chapterModel: PLChapterModel? = chapterGroupModel?.getChapterModelByID(chapterID: chapterID)
        
        if chapterModel == nil || chapterModel?.canPrev() == false || chapterGroupModel?.haveChapter(chapterID: chapterModel!.prevChapterID) == true {
            return;
        }
        
        //请求上一章的数据，得到数据后加入数据集
        //addChapter(text: prevText, chapterID: prevChapterID, currentChapterID: chapterModel.chapterID, type: ChapterPostionType.prev)
    }
    
    override func changePageComplete(chapterID: String) {
        
        self.chapterGroupModel.currentChapterID = chapterID
        
    }


}

