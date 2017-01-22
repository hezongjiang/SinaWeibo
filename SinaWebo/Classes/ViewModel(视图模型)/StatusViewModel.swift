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
    
    /// 微博正文属性文本
    var statusAttrText: NSAttributedString?
    
    /// 转发微博属性文本
    var retweetAttrText: NSAttributedString?
    
    /// 会员图标
    var memberIcon: UIImage?
    
    /// 认证类型：没有认证（-1），认证用户（0），企业认证（2、3、5），达人（220）
    var vipIcon: UIImage?
    
    /// 转发按钮文字
    var retweetString: String?
    
    /// 评论按钮文字
    var commentString: String?
    
    /// 点赞按钮文字
    var likeString: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 微博图片数组
    var pictureUrl: [StatusPicture]? {
        // 如果有被转发的微博有图片，返回被转发微博图片，否则返回原创微博图片
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 行高
    var rowHeight: CGFloat = 0
    
    
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
        
        let retweetText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + "：" + (model.retweeted_status?.text ?? "")
        // 转发微博属性文本
        retweetAttrText = EmoticonManager.manager.emoticonString(string: retweetText, font: UIFont.systemFont(ofSize: 14))
        
        statusAttrText = EmoticonManager.manager.emoticonString(string: model.text ?? "", font: UIFont.systemFont(ofSize: 15))
        
        pictureViewSize = caculatePictureViewSize(count: pictureUrl?.count)
        
        updateRowheight()
    }
    
    /// 根据当前视图模型，计算缓存行高
    private func updateRowheight() {
        
        var height:CGFloat = 0
        
        let iconHeight: CGFloat = 34
        
        let toolBarHeight:CGFloat = 35
        
        // 顶部高度
        height = OutterMargin * 2 + iconHeight + OutterMargin
        
        let viewSize = CGSize(width: UIScreen.main.bounds.width - 2 * OutterMargin, height: CGFloat(MAXFLOAT))
        
        // 正文高度
        if let text = statusAttrText {
            
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        // 转发微博高度
        if status.retweeted_status != nil {
            
            height += 2 * OutterMargin
            
            if let text = retweetAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        height += pictureViewSize.height
        
        height += OutterMargin
        
        // 底部工具栏高度
        height += toolBarHeight
        
        rowHeight = height
    }
    
    /// 计算单张配图大小
    func calculateSiginPicture(image: UIImage) {
        
        var size = image.size
        
        size.height += OutterMargin
        
        pictureViewSize = size
        
        updateRowheight()
    }
    
    /// 计算配图视图尺寸
    private func caculatePictureViewSize(count: Int?) -> CGSize {
        
        guard let count = count, count != 0 else { return CGSize() }
        
        // 行数
        let row = CGFloat((count - 1) / 3 + 1)
        // 高度
        let height = OutterMargin + (row - 1) * PictureViewInnerMargin + row * PictureViewItemWidth
        
        return CGSize(width: PictureViewWidth, height: height)
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
