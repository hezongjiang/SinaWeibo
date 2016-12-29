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
    
    override var description: String {
        return yy_modelDescription()
    }
}
