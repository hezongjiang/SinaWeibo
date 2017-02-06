//
//  ComposeTextView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/23.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    /// 占位标签
    lazy var placeholderLabel: UILabel = { //[weak self] in
        
        let label = UILabel()
        label.text = "分享新鲜事……"
        label.font = self.font
        label.textColor = UIColor.lightGray
        label.frame.origin = CGPoint(x: 5, y: 8)
        label.sizeToFit()
        return label
    }()
    
    /// 插入表情
    func insert(emotion: Emoticon) {
        
        if let emoji = emotion.emoji, let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            return
        }
        
        let attrString = NSMutableAttributedString(attributedString: attributedText)
        
        attrString.replaceCharacters(in: selectedRange, with: emotion.imageAttributedString(font: font!))
        
        let range = selectedRange
        
        attributedText = attrString
        
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        delegate?.textViewDidChange?(self)
    }
    
    /// 发送给服务器的文本
    var emotionText: String {
        
        var result = ""
        
        // 遍历输入视图的属性字符串
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dict, range, _) in
            print(dict)
            if let attachment = dict["NSAttachment"] as? EmoticonTextAttachment {
                result += attachment.chs ?? ""
            } else {
                result += (attributedText.string as NSString).substring(with: range)
            }
        }
        return result
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(placeholderLabel)
    }
/*
    override var text: String! {
        didSet {
            delegate?.textViewDidChange?(self)
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            delegate?.textViewDidChange?(self)
        }
    }*/
}
