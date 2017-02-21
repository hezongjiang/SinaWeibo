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
                
                imageView?.subviews.first?.isHidden = ((picture.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif"
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
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = i
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let xOffset = col * (PictureViewItemWidth + PictureViewInnerMargin)
            let yOffset = row * (PictureViewItemWidth + PictureViewInnerMargin)
            
            imageView.frame = imageView.frame.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(imageView)
            
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageView)))
            
            
            let label = UILabel()
            label.text = "GIF"
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 11)
            label.textAlignment = .center
            label.isHidden = true
            imageView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            imageView.addConstraint(NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 0))
            imageView.addConstraint(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0))
            imageView.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22))
            imageView.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12))
        }
    }
    
    /// 点击图片
    func tapImageView(tap: UITapGestureRecognizer) {
        
        var imageUrl = [String]()
        var imageViews = [UIImageView]()
        
        for statusPicture in pictures ?? [] {
            
            guard let urlString = statusPicture.large_pic else { continue }
            
            imageUrl.append(urlString)
        }
        
        for imageView in subviews {
            
            guard let iv = imageView as? UIImageView else { continue }
            
            if !iv.isHidden { imageViews.append(iv) }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification), object: nil, userInfo: ["urls" : imageUrl, "imageViews" : imageViews, "selectedIndex" : tap.view?.tag ?? 0])
    }
}
