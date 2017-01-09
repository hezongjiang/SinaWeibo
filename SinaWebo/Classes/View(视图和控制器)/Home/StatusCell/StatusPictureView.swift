//
//  StatusPictureView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/6.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class StatusPictureView: UIView {

    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    var pictures: [StatusPicture]? {
        didSet {
            
            for view in subviews {
                view.isHidden = true
            }
            
            var index = 0
            for picture in(pictures ?? []) {
                
                if pictures?.count == 4 && index == 2 {
                    index += 1
                }
                
                let imageView = subviews[index] as? UIImageView
                
                imageView?.setImage(urlString: picture.thumbnail_pic, placeholderImage: nil)
                imageView?.isHidden = false
                
                index += 1
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
    
        backgroundColor = superview?.backgroundColor
        
        for i in 0..<9 {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: pictureViewOutterMargin, width: itemWidth, height: itemWidth))
            imageView.backgroundColor = UIColor.red
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let xOffset = col * (itemWidth + pictureViewInnerMargin)
            let yOffset = row * (itemWidth + pictureViewInnerMargin)
            
            imageView.frame = imageView.frame.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(imageView)
            
        }
    }
}
