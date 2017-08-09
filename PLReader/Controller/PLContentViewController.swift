//
//  PLContentViewController.swift
//  PLReader
//
//  Created by xiong on 2017/8/8.
//  Copyright © 2017年 xiong. All rights reserved.
//

import UIKit

class PLContentViewController: UIViewController {
    
    var ID: Int?
    
    var contentView: PLContentView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showFrame(frame: CTFrame, config: PLTextConfigModel){
        if contentView == nil {
            contentView = PLContentView()
            view.addSubview(contentView!)
        }
        
        view.backgroundColor = config.backgroundColor
        contentView?.backgroundColor = config.backgroundColor

        let contentW = config.contextRect.width
        let contentH = config.contextRect.height
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let statusBarH = UIApplication.shared.statusBarFrame.height
        contentView!.frame = CGRect.init(x: (screenW - contentW)/2.0, y: statusBarH + (screenH - contentH)/2.0, width: contentW, height: contentH)
        contentView!.showFrame(frame: frame, bgColor: config.backgroundColor)
    }
}
