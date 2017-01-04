//
//  UserAccount.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/3.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

private let userAccountFile: NSString = "user_account.json"

class UserAccount: NSObject {

    /// 访问令牌
    var access_token: String?
    /// 用户代号
    var uid: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name: String?
    
    
    /// 头像
    var avatar_large: String?
    
    
    override init() {
        super.init()
        
        guard let filePath = userAccountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: filePath),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: [.mutableContainers]) as? [String : Any] else {
            return
        }
        
        yy_modelSet(with: dict ?? [:])
        
        if expiresDate?.compare(Date()) == .orderedDescending {
            print("账号正常")
        } else {
            print("账号过期")
            access_token = nil
            uid = nil
            
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    /// 存储账号信息到本地
    func savaAccount() {
        
        let data = self.yy_modelToJSONData()
        
        guard let filePath = userAccountFile.cz_appendDocumentDir() else {
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        try? data?.write(to: url)
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
