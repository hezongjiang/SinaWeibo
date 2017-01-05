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
    
    
    init(model: Status) {
        
        status = model
        
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
