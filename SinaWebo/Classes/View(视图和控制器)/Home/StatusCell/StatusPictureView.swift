//
//  StatusPictureView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/6.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class StatusPictureView: UIView {
    
    var viewModel: StatusViewModel? {
        
        didSet {
            calculate()
            
            pictures = viewModel?.pictureUrl
        }
    }
    
    private func calculate() {
        
        
        if viewModel?.pictureUrl?.count == 1 { // 处理单张图片，按图片原始宽高比显示
            
            let size = viewModel?.pictureViewSize ?? CGSize()
            
            subviews[0].frame = CGRect(x: 0, y: OutterMargin, width: size.width, height: size.height - OutterMargin)
            
        } else { // 其他情况，图片按照正方形显示
            
            subviews[0].frame = CGRect(x: 0, y: OutterMargin, width: PictureViewItemWidth, height: PictureViewItemWidth)
        }
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    /// 配图高度
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    /// 配图数组，如果被转发的微博有图片，返回被转发微博图片，否则返回原创微博图片
    private var pictures: [StatusPicture]? {
        
        didSet {
            
            for view in subviews { view.isHidden = true }
            
            var index = 0
            for picture in(pictures ?? []) {
                
                if pictures?.count == 4 && index == 2 { index += 1 }
                
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
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: OutterMargin, width: PictureViewItemWidth, height: PictureViewItemWidth))
            imageView.backgroundColor = UIColor.red
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let xOffset = col * (PictureViewItemWidth + PictureViewInnerMargin)
            let yOffset = row * (PictureViewItemWidth + PictureViewInnerMargin)
            
            imageView.frame = imageView.frame.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(imageView)
            
        }
    }
}
