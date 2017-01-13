//
//  RefreshView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/12.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class RefreshView: UIView {

    class func refreshView() -> RefreshView {
        return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)?.first as! RefreshView
    }
    
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!

    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = superview?.backgroundColor
    }
}
