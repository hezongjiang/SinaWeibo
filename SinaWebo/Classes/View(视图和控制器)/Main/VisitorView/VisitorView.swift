//
//  VisitorView.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/28.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var visitorInfo: [String : String]? {
        didSet {
            
            guard let tipMessage = visitorInfo?["message"], let imageName = visitorInfo?["imageName"] else {
                return
            }
            
            tipLable.text = tipMessage
            
            if imageName == "" {
                startAnimation()
                return
                
            } else {
                
                iconView.image = UIImage(named: imageName)
                houseIconView.isHidden = true
                maskIconView.isHidden = true
            }
        }
    }
    
    /// 图像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    /// 遮盖
    private lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    /// 小房子
    private lazy var houseIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 提示标签
    private lazy var tipLable: UILabel = UILabel.cz_label(withText: "添加一些好友，看看有什么惊喜！", fontSize: 16, color: UIColor.darkGray)
    
    /// 注册按钮
    lazy var registerBtn: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")
    
    /// 登录按钮
    lazy var loginBtn: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.gray, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")
    
    
    /// 旋转动画
    private func startAnimation() {
        
        let anima = CABasicAnimation(keyPath: "transform.rotation")
        anima.toValue = 2 * M_PI
        anima.repeatCount = MAXFLOAT
        anima.isRemovedOnCompletion = false
        anima.duration = 12
        iconView.layer.add(anima, forKey: nil)
        
    }
    
    /// 设置界面
    private func setupUI() {
        
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLable)
        addSubview(registerBtn)
        addSubview(loginBtn)
        tipLable.textAlignment = .center
        for view in subviews {
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -40))
        
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 240))
        
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .top, relatedBy: .equal, toItem: tipLable, attribute: .bottom, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .left, relatedBy: .equal, toItem: tipLable, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110))
        
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: tipLable, attribute: .bottom, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .right, relatedBy: .equal, toItem: tipLable, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110))
        
        let viewDict = ["maskIconView" : maskIconView, "registerBtn" : registerBtn] as [String : Any]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-0-[registerBtn]", options: [], metrics: nil, views: viewDict))
        
        
    }
}
