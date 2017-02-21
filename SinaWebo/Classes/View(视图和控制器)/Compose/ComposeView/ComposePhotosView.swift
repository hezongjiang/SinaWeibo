//
//  ComposePhotosView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/2/20.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposePhotosView: UIView {

    
    fileprivate(set) var photos = [UIImage]()
    
    func addPhoto(photo: UIImage) {
        
        let imageView = UIImageView(image: photo)
        
        addSubview(imageView)
        
        photos.append(photo)
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let maxCol = 3;
        let imageWH: CGFloat = 70;
        let imageMargin: CGFloat = 10;
        
        for (i, imageView) in (subviews as! [UIImageView]).enumerated() {
            let col = CGFloat(i % maxCol)
            let row = CGFloat(i / maxCol)
            
            imageView.frame = CGRect(x: col * (imageMargin + imageWH), y: row * (imageMargin +  imageWH), width: imageWH, height: imageWH)
        }
    }
    
}
