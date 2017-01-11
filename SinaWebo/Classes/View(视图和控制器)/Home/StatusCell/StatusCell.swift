//
//  StatusCell.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
            // 用户名
            nameLabel.text = viewModel?.status.user?.screen_name
            // 微博正文
            statusLabel.text = viewModel?.status.text
            // 会员图标
            memberIcon.image = viewModel?.memberIcon
            // VIP图标
            vipIcon.image = viewModel?.vipIcon
            // 头像
            iconView.setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_small"), isAvatar: true)
            // 来源
            sourceLaebl.text = "来自" + (viewModel?.status.source ?? "")
            // 时间
            timeLabel.text = viewModel?.status.created_at
            // 配图视图高度
            pictureView.viewModel = viewModel
            // 配图
            toolBar.viewModel = viewModel
            
            pictureView.pictures = viewModel?.pictureUrl
            
            tetweetLabel?.text = viewModel?.retweetText
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
    @IBOutlet weak var statusLabel: UILabel!
    
    /// 配图视图
    @IBOutlet weak var pictureView: StatusPictureView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: StatusToolBar!
    
    /// 被转发微博文字
    @IBOutlet weak var tetweetLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
