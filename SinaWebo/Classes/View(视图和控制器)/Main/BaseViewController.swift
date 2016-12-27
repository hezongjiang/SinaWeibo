//
//  BaseViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    open lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    open lazy var navItem: UINavigationItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem];
        
        view.backgroundColor = UIColor.cz_random()
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    

}
