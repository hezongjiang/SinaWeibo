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

@objc protocol EmoticonCellDelegate {
    
    /// 点击表情代理监听方法
    ///
    /// - Parameters:
    ///   - cell: 选中的Cell
    ///   - emotion: 点击的表情模型。若为nil，则为点击了删除按钮。
    func emoticonCell(_ cell: EmoticonCell, didSelectedEmotion emotion: Emoticon?)
}

/// 表情键盘每一页的Cell，一个Cell上添加20个表情
class EmoticonCell: UICollectionViewCell {
    
    /// 表情选择提示视图
    private lazy var tipView: EmoticonTipView = EmoticonTipView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: EmoticonCellDelegate?
    
    var emoticons: [Emoticon]? {
        
        didSet {
            
            for view in contentView.subviews { view.isHidden = true }
            contentView.subviews.last?.isHidden = false
            for (idx, emoticon) in (emoticons ?? []).enumerated() {
                
                if let btn = contentView.subviews[idx] as? UIButton {
                    
                    btn.setImage(emoticon.image, for: .normal)
                    btn.setTitle(emoticon.emoji, for: .normal)
                    btn.isHidden = false
                }
            }
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let window = newWindow else { return }
        tipView.isHidden = true
        window.addSubview(tipView)
    }
    

    /// 表情按钮点击
    @objc fileprivate func selectedEmoticon(button: UIButton) {
        
        var em: Emoticon?
        
        if button.tag < emoticons?.count ?? 0 {
            em = emoticons?[button.tag]
        }
        
        delegate?.emoticonCell(self, didSelectedEmotion: em)
    }
    
    /// 表情按钮长按
    @objc fileprivate func longGesture(gesture: UILongPressGestureRecognizer) {
        
        guard let btn = buttonWithLocation(gesture.location(in: self)) else {
            tipView.isHidden = true
            return
        }
        
        switch gesture.state {
            
        case .began, .changed:
            
            tipView.isHidden = false
            
            tipView.center = convert(btn.center, to: nil)
            
            if btn.tag < emoticons?.count ?? 0 {
                
                tipView.emotion = emoticons?[btn.tag]
            }
            
        case .ended:
            
            tipView.isHidden = true
            selectedEmoticon(button: btn)
            
        case .cancelled, .failed:
            tipView.isHidden = true
            
        default: break
            
        }
    }
    
    /// 获取触摸位置的按钮
    ///
    /// - Parameter location: 手指触摸的位置
    /// - Returns: 按钮
    private func buttonWithLocation(_ location: CGPoint) -> UIButton? {
        
        for btn in contentView.subviews {
            
            if !btn.isHidden && btn.frame.contains(location) && btn != contentView.subviews.last {
                return btn as? UIButton
            }
        }
        
        return nil
    }
}

private extension EmoticonCell {
    
    func setupUI() {
        
        for i in 0...maxCount {
            
            let leftMargin: CGFloat = 8
            let bottomMargin: CGFloat = 16
            
            let width = (bounds.width - 2 * leftMargin) / CGFloat(maxColCount)
            let height = (bounds.height - bottomMargin) / CGFloat(maxRowCount)
            
            let row = i / maxColCount
            let col = i % maxColCount
            
            let btn = UIButton(frame: CGRect(x: leftMargin + CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height))
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticon), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            contentView.addSubview(btn)
        }
        
        let btn = contentView.subviews.last as? UIButton
        
        btn?.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
        
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longGesture(gesture:))))
    }
}
