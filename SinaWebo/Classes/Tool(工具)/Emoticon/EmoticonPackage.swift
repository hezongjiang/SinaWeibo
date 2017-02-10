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
    var emoticons = [Emoticon]()
    
    
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
    
    /// 表情键盘底部工具栏背景图片名
    var bgImageName: String?
    
    /// 表情页数
    var numberOfPage: Int {
        
        return (emoticons.count - 1) / maxCount + 1
    }
    
    func emoticon(page: Int) -> [Emoticon] {
        
        let location = maxCount * page
        var length = maxCount
        
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange(location: location, length: length)
        
        return (emoticons as NSArray).subarray(with: range) as! [Emoticon]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
