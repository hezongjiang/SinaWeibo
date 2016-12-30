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
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, complentionRequest: @escaping (_ list: [[String : AnyObject]]?, _ isSuccess:Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let paramet = ["since_id" : "\(since_id)" as AnyObject, "max_id" : "\(max_id > 0 ? max_id - 1 : 0)" as AnyObject]
        
        accessTokenRequest(URLString: urlString, parameters: paramet) { (json, isSuccess)->() in
            
            let result = json?["statuses"] as? [[String : AnyObject]]
            
            complentionRequest(result, isSuccess)
        }

    }
    
    /// 请求微博未读数
    func unreadCount(complention: @escaping (_ unreadCount: Int) -> ()) {
        
        let url = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        
        accessTokenRequest(URLString: url, parameters: ["uid" : uid as AnyObject]) { (json, isSuccess) -> () in

            let count = json?["status"] as? Int ?? 0
            
            complention(count)
            
        }
    }
}
