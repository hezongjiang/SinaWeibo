//
//  StatusListDAL.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/2/7.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// DAL(Data Access Layer)数据访问层，负责处理数据库与网络之间的数据，给 StatusListViewModel 返回微博数据[字典数组]
class StatusListDAL: NSObject {

    
    /// 从本地数据库或者网络加载微博数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上拉刷新id
    ///   - complentionRequest: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, complentionRequest: @escaping (_ list: [[String : Any]]?, _ isSuccess:Bool) -> ()) {
        
        guard let userId = NetworkManager.shared.userAccount.uid else { return }
        
        let array = SQLiteManager.manager.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        if array.count > 0 {
            complentionRequest(array, true)
            return
        } else {
             NetworkManager.shared.statusList(since_id: since_id, max_id: max_id, complentionRequest: { (json, isSuccess) in
                if !isSuccess {
                    complentionRequest(nil, false)
                    return
                }
                
                guard let json = json else {
                    complentionRequest(nil, isSuccess)
                    return
                }
                
                SQLiteManager.manager.updataStatus(userId: userId, status: json)
                
                complentionRequest(json, isSuccess)
             })
        }
    }
        
}
