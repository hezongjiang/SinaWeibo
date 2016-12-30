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
    
    
    /// 访问令牌
    var accessToken: String? = "2.00lw9LYCZ1HVDE6bfc25f95cGLplyC"
    var uid:String? = ""
    
    
    /// accessToken的网络请求
    func accessTokenRequest(method: NetworkMethod = .Get, URLString: String, parameters: [String : AnyObject]?, complentionRequest: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        guard let token = accessToken else {
            // FIXME: 去登录
            print("没有accessToken，需要登录")
            complentionRequest(nil, false)
            return
        }
        
        var parameters = parameters
        if parameters == nil {
            parameters = [String : AnyObject]()
        }
        
        parameters!["access_token"] = token as AnyObject?
        
        // 有accessToken，才请求数据
        request(URLString: URLString, parameters: parameters, complentionRequest: complentionRequest)
    }
    
    
    /// AFN的网络请求封装
    func request(method: NetworkMethod = .Get, URLString: String, parameters: [String : AnyObject]?, complentionRequest: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        let success = { (task: URLSessionTask, json: Any?) -> () in
            complentionRequest(json as AnyObject?, true)
        }
        
        let failure = { (task: URLSessionTask?, error: Error) -> () in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                // FIXME: 去登录
            }
            
            print(error)
            complentionRequest(nil, false)
        }
        
        
        if method == .Get {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
