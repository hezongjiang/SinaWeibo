//
//  EmoticonToolBar.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/24.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

protocol EmoticonToolBarDalegate: NSObjectProtocol {
    func emoticonToolBar(_ toolBar: EmoticonToolBar, didSelectedIndex index: Int)
}

/// 表情键盘底部工具栏
class EmoticonToolBar: UIView {

    /// 选中分组索引
    var selectedIndex = 0 {
        didSet {
            
            guard let buttons = subviews as? [UIButton] else { return }
            
            for btn in buttons {
                btn.isSelected = false
            }
            buttons[selectedIndex].isSelected = true
        }
    }
    
    
    weak var delegate: EmoticonToolBarDalegate?
    
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
    
    @objc fileprivate func barButtonClick(button: UIButton) {
        
        delegate?.emoticonToolBar(self, didSelectedIndex: button.tag)
        selectedIndex = button.tag
    }
}

private extension EmoticonToolBar {
    
    func setupUI() {
        
        for (i, package) in EmoticonManager.manager.emotiPackages.enumerated() {
        
            let btn = UIButton()
            btn.tag = i
            btn.setTitle(package.groupName, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.adjustsImageWhenHighlighted = false
            btn.addTarget(self, action: #selector(barButtonClick(button:)), for: .touchDown)
            if let bgImageName = package.bgImageName {
                let imageName = "compose_emotion_table_\(bgImageName)_normal"
                let imageNameH = "compose_emotion_table_\(bgImageName)_selected"
                btn.setBackgroundImage(UIImage(named: imageName), for: .normal)
                btn.setBackgroundImage(UIImage(named: imageNameH), for: .selected)
                btn.setBackgroundImage(UIImage(named: imageNameH), for: .highlighted)
            }
            addSubview(btn)
            
            if i == 0 { btn.isSelected = true }
        }
    }
}
