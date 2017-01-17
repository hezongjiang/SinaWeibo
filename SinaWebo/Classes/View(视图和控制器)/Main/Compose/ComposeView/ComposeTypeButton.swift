//
//  ComposeTypeButton.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/16.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 要显示控制器的类名
    var className: String?
    
    
    class func composeTypeButton(title: String, image: String) -> ComposeTypeButton {
        
        let btn = Bundle.main.loadNibNamed("ComposeTypeButton", owner: nil, options: nil)?.first as! ComposeTypeButton
        
        btn.imageView.image = UIImage(named: image)
        
        btn.titleLabel.text = title
        
        return btn
    }
}
