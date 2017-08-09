//
//  PLReaderPageViewController.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

enum PLChapterPageShowType: Int {
    case current
    case prev
    case next
}

enum PLReaderContentViewIndex: Int {
    case one
    case two
}

protocol PLReaderPageViewControllerDelegate: class {
    
    func requestNext(chapterID: String)
    
    func requestPrev(chapterID: String)
    
    func changePageComplete(chapterID:String)
}

class PLReaderPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    weak var readerDelegate: PLReaderPageViewControllerDelegate?
    
    private var currentViewController: PLContentViewController?
    
    private var freeViewController: PLContentViewController?
    
    private var pendingViewController: PLContentViewController?
    
    private var chapterGroupModel: PLChapterGroupModel?
    
    private var showNext: Bool = false
    
    private var willChangePageTime: TimeInterval = 0
    
    private var canChangePage: Bool {
        return (Date().timeIntervalSince1970 - willChangePageTime) > 0.4
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
       
        currentViewController = PLContentViewController()
        freeViewController = PLContentViewController()
        
        currentViewController?.ID = PLReaderContentViewIndex.one.rawValue
        freeViewController?.ID = PLReaderContentViewIndex.two.rawValue
        
        delegate = self
        dataSource = self
        willChangePageTime = 0
        
        setViewControllers([currentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }

    
    func addCustomView(customView: UIView) {
        currentViewController!.view.addSubview(customView)
    }
    
    
    
    func showModel(model: PLChapterGroupModel) {
        
        self.view.backgroundColor = PLTextConfigModel.share.backgroundColor
        
        chapterGroupModel = model
        if chapterGroupModel == nil {
            return
        }
        
        updateViewControllerContent(contentController: currentViewController, pageType: PLChapterPageShowType.current)
    }
    
    func updateViewControllerContent(contentController: PLContentViewController?, pageType: PLChapterPageShowType) {
        let pageModel:PLChapterPageModel?
        switch pageType {
        case .current:
            pageModel = chapterGroupModel?.currentPageModel()
        case .next:
            pageModel = chapterGroupModel?.nextPageModel()
        case .prev:
            pageModel = chapterGroupModel?.prevPageModel()
        }
        
        if pageModel != nil && contentController != nil {
            contentController!.showFrame(frame: pageModel!.frameRef!, config: PLTextConfigModel.share)
        }
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewController = pendingViewControllers[0] as? PLContentViewController
        if showNext {
            updateViewControllerContent(contentController: pendingViewController, pageType: PLChapterPageShowType.next)
        } else {
            updateViewControllerContent(contentController: pendingViewController, pageType: PLChapterPageShowType.prev)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished && completed else {
            return
        }
        
        let prevViewController = previousViewControllers[0] as? PLContentViewController
        freeViewController = prevViewController
        currentViewController = pendingViewController
        
        let oldChapterID: String? = chapterGroupModel?.currentChapterID
        if(showNext){
            chapterGroupModel?.moveNext()
            if  chapterGroupModel?.currentChapterID != oldChapterID {
                readerDelegate?.requestNext(chapterID: chapterGroupModel!.currentChapterID)
            }
        } else {
            chapterGroupModel?.movePrev()
            if  chapterGroupModel?.currentChapterID != oldChapterID {
                readerDelegate?.requestPrev(chapterID: chapterGroupModel!.currentChapterID)
            }
        }
        
        readerDelegate?.changePageComplete(chapterID: chapterGroupModel!.currentChapterID)
    }
    
    //MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard canChangePage else {
            return nil
        }
        
        willChangePageTime = Date().timeIntervalSince1970
        
        guard chapterGroupModel?.canMovePrev() == true else {
            return nil
        }
        showNext = false
        return freeViewController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard canChangePage else {
            return nil
        }
        willChangePageTime = Date().timeIntervalSince1970
        
        guard chapterGroupModel?.canMoveNext() == true else {
            return nil
        }
        showNext = true
        return freeViewController
    }

}
