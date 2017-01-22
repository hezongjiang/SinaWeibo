//
//  TextLabel.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/22.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

protocol TextLabelDelegate: NSObjectProtocol {
    
    /// 点击了特殊文字（URL，#话题#，@好友）
    ///
    /// - Parameters:
    ///   - label: TextLabel
    ///   - text: 点击的具体文字
    func label(_ label: TextLabel, didSelectedLinkText text:String)
}

/// attributedText富文本
class TextLabel: UILabel {
    
    weak var delegate: TextLabelDelegate?
    
    // MARK:2.重写属性text方法,可以在ViewController里给文本赋值
    // 一旦label里的内容发生变化,就可以让textStorage相应变化
    override var text:String? {
        didSet {
            prepareTextStorage()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            prepareTextStorage()
        }
    }
    
    /// 换行处理属性
    func breakLine() {
        
        let attrStringM = addLineBreak(attrString: textStorage)
        //换行后进行--正则匹配
        regexLinkRanges(attrString: attrStringM)
        //换行后进行--连接颜色设置
        addLinkAttribute(attrStringM: attrStringM)
        //添加到textStorage
        textStorage.setAttributedString(attrStringM)
        //重新绘制
        setNeedsDisplay()
    }
    
    // MARK: - textKit的三个核心对象
    /// 属性文本存储
    fileprivate lazy var textStorage = NSTextStorage()
    /// 负责文本字形布局对象
    fileprivate lazy var layoutManager = NSLayoutManager()
    /// 设定文本绘制的范围
    fileprivate lazy var textContainer = NSTextContainer()
    /// 匹配所有连接颜色:URL,#话题#,@好友
    fileprivate lazy var linkRanges = [NSRange]()
    
    // MARK:纯代码接管Label
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    // MARK:1.Xib接管Label
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
    }
    
    func prepareTextSystem() {
        
        isUserInteractionEnabled = true
        prepareTextStorage()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    
    /// 使用textStorage接管label的内容
    func prepareTextStorage() {
        
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        } else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        } else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        breakLine()
    }
    
    // MARK:2.1.段落样式处理
    fileprivate func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        if attrStringM.length == 0 {
            return attrStringM
        }
        //从(0,0)点开始,也就是从text的第一个字符开始
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle
        
        //设置段落样式--以字符分割,不以单词分割
        if paragraphStyle != nil {
            //ByWordWrapping//按照单词分割换行，保证换行时的单词完整。
            //ByCharWrapping按照字母换行，可能会在换行时将某个单词拆分到两行
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byCharWrapping
        } else {
            // iOS 8.0 不能直接获取段落的样式
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byCharWrapping
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            attrStringM.setAttributes(attributes, range: range)
        }
        return attrStringM
    }
    
    // MARK:2.2.连接的attribute的颜色设置
    fileprivate func addLinkAttribute(attrStringM: NSMutableAttributedString) {
        if attrStringM.length == 0 { return }
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange:  &range)
        attrStringM.addAttributes(attributes, range: range)
        attributes[NSForegroundColorAttributeName] = UIColor.init(red: 0.15, green: 0.6, blue: 1, alpha: 1)
        for range in linkRanges {
            attrStringM.setAttributes(attributes, range: range)
        }
    }
    
    // MARK:2.3.正则法则--匹配所有连接颜色:URL,#话题#,@好友---放到一个数组里
    fileprivate let patterns = ["((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:[a-zA-Z0-9]{3}_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    
    fileprivate func regexLinkRanges(attrString: NSAttributedString) {
        //存储所有的匹配结果前,将原来的清空
        linkRanges.removeAll()
        //正则匹配范围--整个label
        let regexRange = NSRange(location: 0, length: attrString.string.characters.count)
        for pattern in patterns {
            //创建正则
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else { return }
            //匹配
            let results = regex.matches(in: attrString.string, options:NSRegularExpression.MatchingOptions(rawValue: 0) , range: regexRange)
            for result in results {      //每一种正则法则可能匹配到多个符合要求的对象如@张三  @李四 匹配到两个,结果是个数组
                let range = result.rangeAt(0)
                linkRanges.append(range)
            }
        }
    }
    
    // MARK:3.设置布局--制定文本绘制区域
    override func layoutSubviews() {
        super.layoutSubviews()
        //制定文本绘制区域
        textContainer.size = bounds.size
    }
    
    // MARK:4.绘制textStorage的文本内容--不能调用super
    override func drawText(in rect: CGRect) {
        let range = NSMakeRange(0, textStorage.length)
        
        // 绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        
        // Glyphs--字形---CGPoint()从原点绘制,也就是右上角
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    // MARK:5.用户点击事件交互--处理不同匹配内容天转到不同界面
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        set(touches: touches, textAttributes: [NSBackgroundColorAttributeName : UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)], isTouchesEnded: false)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let color = superview?.backgroundColor ?? UIColor.white
        set(touches: touches, textAttributes: [NSBackgroundColorAttributeName : color], isTouchesEnded: true)
    }
    
    private func set(touches: Set<UITouch>, textAttributes attrs: [String : Any], isTouchesEnded ended: Bool) {
        // 获取用户点击的位置
        guard let point = touches.first?.location(in: self) else { return }
        
        // 获取当前点击字符的索引
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        // 找出@谁
        
        var subString = ""
        
        for range in atRange {
            if NSLocationInRange(index, range) {
                subString = (textStorage.string as NSString).substring(with: range)
                textStorage.addAttributes(attrs, range: range)
                setNeedsDisplay()
            }
        }
        // 找出URL,#话题#,@好友
        for range in linkRanges {
            if NSLocationInRange(index, range) {
                subString = (textStorage.string as NSString).substring(with: range)
                textStorage.addAttributes(attrs, range: range)
                setNeedsDisplay()
            }
        }
        // 找出URL
        for range in urlRange {
            if NSLocationInRange(index, range) {
                subString = (textStorage.string as NSString).substring(with: range)
                textStorage.addAttributes(attrs, range: range)
                setNeedsDisplay()
            }
        }
        
        if subString.characters.count > 0 && ended {
            delegate?.label(self, didSelectedLinkText: subString)
        }
    }
}

// MARK: 正则表达式处理结果
private extension TextLabel {
    
    /// 正则表达式--@好友
    var atRange:[NSRange] {
        
        let pattern = "@[\u{4e00}-\u{9fa5}]{0,}"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        //多重匹配--//let matchs: [NSTextCheckingResult]
        let matchs = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0,length: textStorage.length))
        //遍历数组
        var ranges = [NSRange]()
        for match in matchs { ranges.append(match.rangeAt(0)) }
        return ranges
    }
    
    /// 返回textStorage中的话题## 的range数组
    var jingRange:[NSRange] {
        
        let pattern = "#[\u{4e00}-\u{9fa5}]{0,}#"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        
        //多重匹配--//let matchs: [NSTextCheckingResult]
        let matchs = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0,length: textStorage.length))
        //遍历数组
        var ranges = [NSRange]()
        for match in matchs { ranges.append(match.rangeAt(0)) }
        return ranges
    }
    
    /// 返回textStorage中的URL网址的range数组
    var urlRange:[NSRange] {
        
        let pattern = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:[a-zA-Z0-9_/=<>]]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        //多重匹配--//let matchs: [NSTextCheckingResult]
        let matchs = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0,length: textStorage.length))
        //遍历数组
        var ranges = [NSRange]()
        for match in matchs { ranges.append(match.rangeAt(0)) }
        return ranges
    }
}

