//
//  NetworkManager.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/29.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import AFNetworking

enum NetworkMethod {
    case Get
    case Post
}

/// AFN的网络工具类
class NetworkManager: AFHTTPSessionManager {

    /// 单例
    static let shared = NetworkManager()
    
    /// AFN的请求封装
    func request(method: NetworkMethod = .Get, URLString: String, parameters: [String : AnyObject]?, complention: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        let success = { (task: URLSessionTask, json: Any?) -> () in
            complention(json as AnyObject?, true)
        }
        
        let failure = { (task: URLSessionTask?, error: Error) -> () in
            print(error)
            complention(nil, false)
        }
        
        
        if method == .Get {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
