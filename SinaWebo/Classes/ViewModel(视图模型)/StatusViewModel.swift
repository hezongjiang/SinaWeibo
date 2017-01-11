//
//  StatusViewModel.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 首页单条数据视图模型
class StatusViewModel: NSObject {

    /// 微博模型
    var status: Status
    
    /// 会员图标
    var memberIcon: UIImage?
    
    /// 认证类型：没有认证（-1），认证用户（0），企业认证（2、3、5），达人（220）
    var vipIcon: UIImage?
    
    /// 转发
    var retweetString: String?
    
    /// 评论
    var commentString: String?
    
    /// 点赞
    var likeString: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 微博图片数组
    var pictureUrl: [StatusPicture]? {
        // 如果有被转发的微博有图片，返回被转发微博图片，否则返回原创微博图片
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博问字
    var retweetText: String?
    
    
    
    init(model: Status) {
        
        status = model
        
        super.init()
        
        // 设置会员图片
        setupVipAndMemberIcon(model: model)
        
        // 设置底部工具栏数据
//        model.reposts_count = Int(arc4random_uniform(100000))
        retweetString = countString(count: model.reposts_count, defaultString: "转发")
        commentString = countString(count: model.comments_count, defaultString: "评论")
        likeString = countString(count: model.attitudes_count, defaultString: "赞")
        
        retweetText = model.retweeted_status?.text
        
        pictureViewSize = caculatePictureViewSize(count: pictureUrl?.count)
    }
    
    /// 计算单张配图大小
    func calculateSiginPicture(image: UIImage) {
        
        var size = image.size
        
        size.height += pictureViewOutterMargin
        
        pictureViewSize = size
    }
    
    /// 计算配图视图尺寸
    private func caculatePictureViewSize(count: Int?) -> CGSize {
        
        guard let count = count, count != 0 else { return CGSize() }
        
        // 行数
        let row = CGFloat((count - 1) / 3 + 1)
        // 高度
        let height = pictureViewOutterMargin + (row - 1) * pictureViewInnerMargin + row * itemWidth
        
        return CGSize(width: pictureViewWidth, height: height)
    }
    
    // Cell底部工具栏数字计算
    private func countString(count: Int, defaultString: String) -> String {
        
        if count == 0 { return defaultString }
        
        if count < 10000 { return count.description }
        
        return String(format: "%.2f万", CGFloat(count) / 10000.0)
    }
    
    /// 设置会员图片
    private func setupVipAndMemberIcon(model: Status) {
        
        let rank = model.user?.mbrank ?? 0
        
        if rank > 0 && rank < 7 {
            
            memberIcon = UIImage(named: "common_icon_membership_level\(rank)")
        }
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
