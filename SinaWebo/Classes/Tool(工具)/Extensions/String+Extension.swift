
//
//  String+Extension.swift
//  正则表达式
//
//  Created by Hearsay on 2017/1/17.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import Foundation

extension String {
    
    
    /// 获取微博来源和链接
    func wb_source() -> (href: String, text: String)? {
        
        let pattern = "<a href=\"(.*?)\".*?\">(.*?)</a>"
        
        let regx = try? NSRegularExpression(pattern: pattern, options: [])
        
        
        guard let result = regx?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else {
            print("没有找到")
            return nil
        }
        
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link, text)
    }
}
