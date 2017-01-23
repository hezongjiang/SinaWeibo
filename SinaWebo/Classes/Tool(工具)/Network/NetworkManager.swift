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

/// AFNetworking的网络工具类
class NetworkManager: AFHTTPSessionManager {

    /// 单例
    static let shared: NetworkManager = {
       
        let instance = NetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    /// 用户信息模型
    lazy var userAccount = UserAccount()
    
    
    
    
    /// 根据access_token发起网络请求
    func accessTokenRequest(method: NetworkMethod = .Get, urlString: String, parameters: [String : Any]?, name: String? = nil, data: Data? = nil, complentionRequest: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        

        guard let token = userAccount.access_token else {
            
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
        if let name = name, let data = data {
            upload(urlString: urlString, name: name, data: data, parameters: parameters, complentionRequest: complentionRequest)
        } else {
            request(method: method, URLString: urlString, parameters: parameters, complentionRequest: complentionRequest)
        }
    }
    
    
    /// 封装AFN GET/POST 方法
    ///
    /// - Parameters:
    ///   - method: Get or Post
    ///   - URLString: url字符串
    ///   - parameters: 请求参数字典
    ///   - complentionRequest: 网络请求完成回调
    func request(method: NetworkMethod = .Get, URLString urlString: String, parameters: [String : Any]?, complentionRequest: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        
        let success = { (task: URLSessionTask, json: Any?) -> () in
            complentionRequest(json, true)
        }
        
        let failure = { (task: URLSessionTask?, error: Error) -> () in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: "bad_access_token")
            }
            
            print(error)
            complentionRequest(nil, false)
        }
        
        if method == .Get {
            
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
    
    /// 封装AFN上传文件方法
    ///
    /// - Parameters:
    ///   - urlString: URLString
    ///   - name: 接受上传数据的服务器字段
    ///   - data: 上传文件的二进制数据
    ///   - parameters: 参数
    ///   - complentionRequest: 完成回调
    func upload(urlString: String, name: String, data: Data, parameters: [String : Any]?, complentionRequest: @escaping (_ json: Any?, _ isSuccess: Bool) -> ()) {
        
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            formData.appendPart(withFileData: data, name: name, fileName: "image", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, json) in
            
            complentionRequest(json, true)
            
        }) { (task, error) in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: "bad_access_token")
            }
            
            print(error)
            complentionRequest(nil, false)
        }
    }
}
