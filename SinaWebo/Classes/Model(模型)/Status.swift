//
//  Sataus.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import YYModel

/// 微博数据模型
class Status: NSObject {

    /// 微博id
    var id: Int64 = 0
    
    /// 微博正文
    var text: String?
    
    /// 转发数
    var reposts_count: Int = 0
    
    /// 评论数
    var comments_count: Int = 0
    
    /// 表态数
    var attitudes_count: Int = 0
    
    /// 微博来源
    var source: String? {
        didSet {
            guard let sour = source?.wb_source()?.text else { return }
            source = "来自 " + sour
        }
    }
    
    /// 微博创建时间
    var created_at: String?
    
    /// 微博用户
    var user: User?
    
    /// 配图视图数组
    var pic_urls: [StatusPicture]?
    
    /// 被转发微博
    var retweeted_status: Status?
    
    
    class func modelContainerPropertyGenericClass() -> [String : AnyClass] {
        return ["pic_urls" : StatusPicture.self]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
