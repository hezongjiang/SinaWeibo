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
            
            nameLabel.text = viewModel?.status.user?.screen_name
            
            statusLabel.text = viewModel?.status.text
            
            memberIcon.image = viewModel?.memberIcon
            
            vipIcon.image = viewModel?.vipIcon
            
            iconView.setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_small"), isAvatar: true)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
