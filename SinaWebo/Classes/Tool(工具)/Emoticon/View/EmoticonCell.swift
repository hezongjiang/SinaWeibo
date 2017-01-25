//
//  EmoticonCell.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/24.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 最大行数
private let maxRowCount = 3

/// 最大列数
private let maxColCount = 7

/// 每一页表情的最大数量
let maxCount = maxRowCount * maxColCount - 1


/// 表情键盘每一页的Cell，一个Cell上添加20个表情
class EmoticonCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emoticons: [Emoticon]? {
        
        didSet {
            
            for view in contentView.subviews {
                view.isHidden = true
            }
            
            
            for (idx, emoticon) in (emoticons ?? []).enumerated() {
                
                if let btn = contentView.subviews[idx] as? UIButton {
                    
                    btn.setImage(emoticon.image, for: .normal)
                    btn.setTitle(emoticon.emoji, for: .normal)
                    btn.isHidden = false
                }
            }
            
        }
    }
    

}

private extension EmoticonCell {
    
    func setupUI() {
        
        for i in 0..<(maxRowCount * maxColCount) {
            
            let leftMargin: CGFloat = 8
            let bottomMargin: CGFloat = 16
            
            let width = (bounds.width - 2 * leftMargin) / CGFloat(maxColCount)
            let height = (bounds.height - bottomMargin) / CGFloat(maxRowCount)
            
            let row = i / maxColCount
            let col = i % maxColCount
            
            let btn = UIButton(frame: CGRect(x: leftMargin + CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height))
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            contentView.addSubview(btn)
        }
    }
}
