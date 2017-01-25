//
//  Emoticon.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/18.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import YYModel

/// 表情模型
class Emoticon: NSObject {
    
    /// 是否为emoji表情，emoji->true
    var type: Bool = false
    
    /// emoji的十六进制编码
    var code: String? {
        didSet {
            guard let code = code else { return }
            
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    /// emoji字符串
    var emoji: String?
    
    /// 表情字符串（简体）
    var chs: String?
    
    /// 表情字符串繁体）
    var cht: String?
    
    /// 图片名
    var png: String?
    
    /// 图片名
    var gif: String?
    
    /// 图片目录名
    var directory: String?
    
    /// 图片
    var image: UIImage? {
        
        if type { return nil }
        
        guard let directory = directory, let imageName = png else { return nil }
        
        let path = "Emoticons.bundle/\(directory)/"
        
        return UIImage(named: path + imageName)
    }
    
    /// 返回当前模型对应的“图片属性字符串”
    func imageAttributedString(font: UIFont = UIFont.systemFont(ofSize: 17)) -> NSAttributedString {
        
        let attachment = NSTextAttachment()
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -3, width: height, height: height)
        attachment.image = image
        
        let attr = NSAttributedString(attachment: attachment)
        
        return attr
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
