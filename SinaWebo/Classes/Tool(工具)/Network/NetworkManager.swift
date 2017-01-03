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
    static let shared: NetworkManager = {
       
        let instance = NetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    lazy var userAccount = UserAccount()
    
    /// 判断用户是否登录
    var userLogin: Bool {
        return userAccount.access_token != nil
    }
    
    
    /// accessToken的网络请求
    func accessTokenRequest(method: NetworkMethod = .Get, URLString: String, parameters: [String : Any]?, complentionRequest: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        
        guard let token = userAccount.access_token else {
            // FIXME: 去登录
            print("没有accessToken，需要登录")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
            complentionRequest(nil, false)
            return
        }
        
        var parameters = parameters
        if parameters == nil {
            parameters = [String : Any]()
        }
        
        parameters!["access_token"] = token
        
        // 有accessToken，才请求数据
        request(URLString: URLString, parameters: parameters, complentionRequest: complentionRequest)
    }
    
    
    
    /// AFN的网络请求封装
    ///
    /// - Parameters:
    ///   - method: Get or Post
    ///   - URLString: url字符串
    ///   - parameters: 请求参数字典
    ///   - complentionRequest: 网络请求完成回调
    func request(method: NetworkMethod = .Get, URLString: String, parameters: [String : Any]?, complentionRequest: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        
        let success = { (task: URLSessionTask, json: Any?) -> () in
            complentionRequest(json, true)
        }
        
        let failure = { (task: URLSessionTask?, error: Error) -> () in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                // FIXME: 去登录
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
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
