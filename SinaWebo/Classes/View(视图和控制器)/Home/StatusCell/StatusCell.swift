//
//  StatusCell.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

//enum SelectedStringType {
//    case url
//    case topic
//    case at
//}

@objc protocol StatusCellDelegate: NSObjectProtocol {
    
    @objc optional func statusCell(_ statusCell: StatusCell, didSelectedURLString string: String)
}

/// 微博首页Cell
class StatusCell: UITableViewCell {

    weak var delegate: StatusCellDelegate?
    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
            
            // 用户名
            nameLabel.text = viewModel?.status.user?.screen_name
            // 微博正文
            statusLabel.attributedText = viewModel?.statusAttrText
            // 会员图标
            memberIcon.image = viewModel?.memberIcon
            // VIP图标
            vipIcon.image = viewModel?.vipIcon
            // 头像
            iconView.setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_small"), isAvatar: true)
            // 来源
            sourceLaebl.text = (viewModel?.status.source ?? "")
            // 时间
            timeLabel.text = viewModel?.status.created_at
            // 配图视图
            pictureView.viewModel = viewModel
            // 配图
            toolBar.viewModel = viewModel
            
            // 被转发微博文字
            retweetLabel?.attributedText = viewModel?.retweetAttrText
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIcon: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLaebl: UILabel!
    
    /// VIP认证图标
    @IBOutlet weak var vipIcon: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLabel: TextLabel!
    
    /// 配图视图
    @IBOutlet weak var pictureView: StatusPictureView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: StatusToolBar!
    
    /// 被转发微博文字
    @IBOutlet weak var retweetLabel: TextLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
         当你设置drawsAsynchronously为true时，发生了什么？你的drawRect()/drawInContext()方法仍然会被在主线程上调用。但是所有调用Core Graphics的操作都不会被执行。取而代之的是，绘制命令被推迟，并且在后台线程中异步执行。
         
         这种方式就是先记录绘图命令，然后在后台线程中重现。为了这个过程的顺利进行，更多的工作需要被做，更多的内存需要被申请。但是主队列中的一些工作便被移出来了(大概意思就是让我们把一些能在后台实现的工作放到后台实现，让主线程更顺畅)。
         */
        //layer.drawsAsynchronously = true
        
        //layer.shouldRasterize = true
        statusLabel.delegate = self
        retweetLabel?.delegate = self
        
    }

}

extension StatusCell: TextLabelDelegate {
    
    func label(_ label: TextLabel, didSelectedLinkText text: String) {
        
        if text.hasPrefix("http") {
            delegate?.statusCell?(self, didSelectedURLString: text)
        }
    }
}
