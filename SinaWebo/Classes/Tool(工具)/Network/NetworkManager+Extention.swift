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
    
    /// 加载微博数据（字典数组）
    func statusList(complentionRequest: @escaping (_ list: [[String : AnyObject]]?, _ isSuccess:Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        accessTokenRequest(URLString: urlString, parameters: nil) { (json, isSuccess)->() in
            
            let result = json?["statuses"] as? [[String : AnyObject]]
            
            complentionRequest(result, isSuccess)
        }

    }
}
