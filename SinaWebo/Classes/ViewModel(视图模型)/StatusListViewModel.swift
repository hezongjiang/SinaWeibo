//
//  StatusListViewModel.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

private let maxPullupTryTimer = 3

/// 微博数据 视图模型
class StatusListViewModel: NSObject {

    lazy var statusList = [Status]()
    
    private var pullupErrorTimer = 0
    
    /// 加载微博列表
    ///
    /// - isPullup: 是否为上拉刷新
    /// - Parameter completion: 完成回调
    func loadStatus(isPullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shuoleRefresh: Bool) -> ()) {
        
        if isPullup && pullupErrorTimer > maxPullupTryTimer {
            
            completion(false, false)
            return
        }
        
        let since_id = isPullup ? 0 : self.statusList.first?.id ?? 0
        let max_id = !isPullup ? 0 : self.statusList.last?.id ?? 0
        
        NetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: Status.self, json: json ?? []) as? [Status] else {
                completion(isSuccess, false)
                return
            }
            
            print("刷到" + "\(array.count)" + "条数据")
            
            if isPullup {
                
                self.statusList += array
            } else {
                
                self.statusList = self.statusList + array
            }
            
            if isPullup && array.count == 0 {
                self.pullupErrorTimer += 1
                completion(isSuccess, false)
            } else {
                
                completion(isSuccess, true)
            }
            
        }
    }
}
