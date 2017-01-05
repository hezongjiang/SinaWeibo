//
//  User.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 微博用户模型
class User: NSObject {
    
    /// 用户id
    var id: Int64 = 0
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址
    var profile_image_url: String?
    
    /// 认证类型
    var verified_type: Int = 0
    
    /// 会员等级
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}

