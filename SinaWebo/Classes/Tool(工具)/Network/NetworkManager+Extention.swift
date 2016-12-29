//
//  NetworkManager+Extention.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import Foundation

/// 封装新浪微博的请求方法
extension NetworkManager {
    
    /// 加载微博数据字典数组
    func statusList(completion: @escaping (_ list: [[String : AnyObject]]?, _ isSuccess:Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00lw9LYCXYO3CEd74037ad4bilu2hC"
        
        request(URLString: urlString, parameters: nil) { (json, isSuccess)->() in
            
            let result = json?["statuses"] as? [[String : AnyObject]]
            
            completion(result, isSuccess)
        }

    }
}
