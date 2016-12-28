//
//  MainNavViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? BaseViewController {
                
                var title = "返回"
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? title
                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, fontSize: 16, target: self, action: #selector(back), isBack: true)
            }
        }
        
        
        super.pushViewController(viewController, animated: animated)
    }

    @objc func back() {
        popViewController(animated: true)
    }
}
