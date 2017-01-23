//
//  ComposeTextView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/23.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    
    /// 占位标签
    lazy var placeholderLabel: UILabel = { //[weak self] in
        
        let label = UILabel()
        label.text = "分享新鲜事……"
        label.font = self.font
        label.textColor = UIColor.lightGray
        label.frame.origin = CGPoint(x: 5, y: 8)
        label.sizeToFit()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(placeholderLabel)
    }
    
    deinit {
        print("被销毁")
    }

}
