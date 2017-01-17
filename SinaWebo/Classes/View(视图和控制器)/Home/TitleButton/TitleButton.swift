//
//  TitleButton.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/4.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    init(title: String?) {
        
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title!, for: .normal)
            
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        titleLabel.frame.origin.x = 0
        
        imageView.frame.origin.x = titleLabel.bounds.width
        
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }

}
