//
//  UIImageView+WebImage.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    func setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            
            if isAvatar && image != nil {
                
               self?.image = image?.avatarImage(size: self?.bounds.size)
            }
        }
    }
}
