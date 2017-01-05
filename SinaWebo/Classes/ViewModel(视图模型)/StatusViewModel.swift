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

    var status: Status
    
    
    init(model: Status) {
        
        self.status = model
    }
}
