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
    
    var refreshState: RefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipLabel.text = "继续下拉"
                indicator.stopAnimating()
                tipIcon.isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
                
            case .Pulling:
                tipLabel.text = "松手刷新"
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                })
                
            case .WillRefresh:
                tipLabel.text = "正在刷新"
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
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
