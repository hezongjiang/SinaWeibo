//
//  VisitorView.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/28.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    /// 图像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    /// 小房子
    private lazy var houseIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    /// 提示标签
    private lazy var tipLable: UILabel = UILabel.cz_label(withText: "添加一些好友，看看有什么惊喜！", fontSize: 16, color: UIColor.darkGray)
    
    /// 注册按钮
    private lazy var registerBtn: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")
    
    /// 登录按钮
    private lazy var loginBtn: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.gray, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")

}
