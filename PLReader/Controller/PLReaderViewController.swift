//
//  PLReaderViewController.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

enum ChapterPostionType {
    case current
    case prev
    case next
}

class PLReaderViewController: UIViewController, PLReaderPageViewControllerDelegate{
    
    var pageViewController: PLReaderPageViewController!
    
    var chapterGroupModel: PLChapterGroupModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        
        pageViewController = PLReaderPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.pageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        
        chapterGroupModel = PLChapterGroupModel()
        pageViewController!.readerDelegate = self
        
        initCustomView()
    }
    

    func initCustomView() {
        
    }
    
    func show() {
        pageViewController.showModel(model: chapterGroupModel)
        view.backgroundColor = PLTextConfigModel.share.backgroundColor
    }
    
    func addChapter(text: String, chapterID: String, currentChapterID: String, type: ChapterPostionType) -> PLChapterModel? {
        
        let chapterModel = createChapterModel(text: text, chapterID: chapterID)
        if chapterModel != nil {
            switch type {
            case .current:
                chapterGroupModel.clearItems()
                chapterGroupModel.addFirstChapter(model: chapterModel!)
            case .next:
                chapterGroupModel.addNextChapter(model: chapterModel!, currentChapterID: currentChapterID)
            case .prev:
                chapterGroupModel.addPrevChapter(model: chapterModel!, currentChapterID: currentChapterID)
            }
        }
        return chapterModel
    }
    
    func createChapterModel(text: String, chapterID: String) -> PLChapterModel? {
    
        let chapterModel: PLChapterModel = PLTextHandleManager.handleText(text: text, configModel: PLTextConfigModel.share)
        chapterModel.chapterID = chapterID
        
        return chapterModel
    }
    
    
    //MARK: - PLReaderPageViewControllerDelegate
    
    func requestNext(chapterID: String) {
        
    }
    
    func requestPrev(chapterID: String) {
        
    }
    
    func changePageComplete(chapterID: String) {
        
    }

}
