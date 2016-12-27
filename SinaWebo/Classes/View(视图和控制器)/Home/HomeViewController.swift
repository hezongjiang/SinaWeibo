//
//  HomeViewController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cz_random()
        
        nav.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriend))
    }
    
    @objc private func showFriend() {
        navigationController?.pushViewController(MessageViewController(), animated: true)
    }

}
