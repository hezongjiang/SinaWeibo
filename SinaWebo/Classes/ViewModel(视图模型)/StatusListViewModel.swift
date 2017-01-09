//
//  StatusListViewModel.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

private let maxPullupTryTimer = 3

/// 微博首页列表数据的视图模型
class StatusListViewModel: NSObject {

    // 首页数据列表
    lazy var statusList = [StatusViewModel]()
    
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
        
        let since_id = isPullup ? 0 : self.statusList.first?.status.id ?? 0
        let max_id = !isPullup ? 0 : self.statusList.last?.status.id ?? 0
        
        NetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (json, isSuccess) in
            
            if !isSuccess {
                
                completion(false, false)
                return
            }
            
            var array = [StatusViewModel]()
            
            for dict in json ?? [] {
                
                guard let status = Status.yy_model(with: dict) else {
                    continue
                }
                
                array.append(StatusViewModel(model: status))
                
            }
            
//            print("刷到" + "\(array.count)" + "条数据" + "\(array)")
            
            if isPullup {
                
                self.statusList += array
            } else {
                
                self.statusList = array + self.statusList
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
