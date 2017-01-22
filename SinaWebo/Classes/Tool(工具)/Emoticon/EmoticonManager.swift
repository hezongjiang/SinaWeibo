//
//  EmoticonManager.swift
//  图文
//
//  Created by Hearsay on 2017/1/17.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 表情管理者
class EmoticonManager: NSObject {

    /// 单例管理者
    static let manager = EmoticonManager()
    
    /// 表情包，包含全部表情
    fileprivate(set) var emotiPackages = [EmoticonPackage]()
    
    /// 私有化构造器
    private override init() {
        super.init()
        loadPackage()
    }
    
    /// 根据字符串，查找表情模型
    func stringToEmoticon(string: String) -> Emoticon? {
        
        for package in emotiPackages {
            
            let emo = package.emoticons.filter({ (emoticon) -> Bool in
                return emoticon.chs == string
            })
            
            if emo.count != 0 { return emo.first }
        }
        
        return nil
    }
    
    /// 普通文本转图文混排属性文本
    func emoticonString(string: String, font: UIFont = UIFont.systemFont(ofSize: 17)) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: string)
        
        let pattern = "\\[.*?\\]"
        
        guard let rege = try? NSRegularExpression(pattern: pattern, options: []) else {
            return NSAttributedString(string: string)
        }
        
        let results = rege.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
        
        for result in results.reversed() {
            
            let range = result.rangeAt(0)
            
            let subString = (string as NSString).substring(with: range)
            
            
            guard let emoticon = EmoticonManager.manager.stringToEmoticon(string: subString) else {
                continue
            }
            
            attrString.replaceCharacters(in: range, with: emoticon.imageAttributedString(font: font))
        }
        
        attrString.addAttributes([NSFontAttributeName : font], range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }
}

private extension EmoticonManager {
    
    func loadPackage() {
        
        /// 获取表情包目录
        guard let path = Bundle.main.path(forResource: "emoticons", ofType: "plist", inDirectory: "Emoticons.bundle"),
            let plistArr = NSArray(contentsOfFile: path) as? [[String : String]],
            let model = NSArray.yy_modelArray(with: EmoticonPackage.self, json: plistArr) as? [EmoticonPackage] else { return }
        
        emotiPackages += model
    }
    
    
}
