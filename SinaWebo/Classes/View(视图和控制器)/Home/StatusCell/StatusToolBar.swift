//
//  StatusToolBar.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/6.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// Cell底部工具栏
class StatusToolBar: UIView {

    /// 转发
    @IBOutlet weak var retweetButton: UIButton!
    
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    
    /// 点赞
    @IBOutlet weak var likeButton: UIButton!
    
    var viewModel: StatusViewModel? {
        
        didSet {
            retweetButton.setTitle(viewModel?.retweetString ?? "转发", for: .normal)
            commentButton.setTitle(viewModel?.commentString ?? "评论", for: .normal)
            likeButton.setTitle(viewModel?.likeString ?? "赞", for: .normal)
        }
    }
    
    
}
