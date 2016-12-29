//
//  StatusListViewModel.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

/// 微博数据视图模型
class StatusListViewModel: NSObject {

    lazy var statusList = [Status]()
    
    
    /// 加载微博列表
    ///
    /// - Parameter completion: 完成回调
    func loadStatus(completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        NetworkManager.shared.statusList { (json, isSuccess) in
            
            guard let array = NSArray.yy_modelArray(with: Status.self, json: json ?? []) as? [Status] else {
                completion(false)
                return
            }
            
            self.statusList += array
            completion(true)
        }
    }
}
