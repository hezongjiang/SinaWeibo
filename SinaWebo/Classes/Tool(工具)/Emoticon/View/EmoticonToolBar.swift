//
//  EmoticonToolBar.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/24.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 表情键盘底部工具栏
class EmoticonToolBar: UIView {

    override func awakeFromNib() {
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width / CGFloat(subviews.count)
        
        
        for (i, view) in subviews.enumerated() {
            
            view.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: bounds.height)
        }
    }
}

private extension EmoticonToolBar {
    
    func setupUI() {
        
        for package in EmoticonManager.manager.emotiPackages {
        
            let btn = UIButton()
            
            btn.setTitle(package.groupName, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            
            if let bgImageName = package.bgImageName {
                let imageName = "compose_emotion_table_\(bgImageName)_normal"
                let imageNameH = "compose_emotion_table_\(bgImageName)_selected"
                btn.setBackgroundImage(UIImage(named: imageName), for: .normal)
                btn.setBackgroundImage(UIImage(named: imageNameH), for: .selected)
                btn.setBackgroundImage(UIImage(named: imageNameH), for: .highlighted)
            }
//            btn.backgroundColor = UIColor.lightGray
            addSubview(btn)
        }
    }
}
