//
//  EmoticonTipView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/2/10.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit
import pop

class EmoticonTipView: UIImageView {
    
    private lazy var tipButton = UIButton()

    private var currentEmoticon: Emoticon?
    
    /// 当前视图的表情模型
    var emotion: Emoticon? {
        didSet {
            if emotion == currentEmoticon { return }
            tipButton.setImage(emotion?.image, for: .normal)
            tipButton.setTitle(emotion?.emoji, for: .normal)
            currentEmoticon = emotion
            
            // 添加弹性动画
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim?.fromValue = 50
            anim?.toValue = 30
            anim?.springBounciness = 20
            anim?.springSpeed = 20
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    }
    
    
    init() {
        
        super.init(image: UIImage(named: "emoticon_keyboard_magnifier"))
        
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        tipButton.frame = CGRect(x: 0, y: 10, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
