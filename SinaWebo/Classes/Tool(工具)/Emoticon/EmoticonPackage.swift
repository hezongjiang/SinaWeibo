//
//  EmoticonPackge.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/18.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    
    /// 表情数组，里面装每个表情模型
    private(set) var emoticons = [Emoticon]()
    
    
    /// 表情包分组名
    var groupName: String?
    
    /// 表情包目录
    var directory: String? {
        didSet {
            
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "Emoticons.bundle/" +  directory + "/info", ofType: "plist"),
                let json = NSArray(contentsOfFile: path) as? [[String : String]],
                let models = NSArray.yy_modelArray(with: Emoticon.self, json: json) as? [Emoticon] else { return }
            
            for model in models {
                model.directory = directory
            }
            
            emoticons = models
        }
    }
    
    var bgImageName: String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
