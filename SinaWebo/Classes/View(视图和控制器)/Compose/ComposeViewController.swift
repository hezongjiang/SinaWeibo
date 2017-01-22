//
//  ComposeViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/22.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cz_random()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(back))
    }
    
    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
    
}
