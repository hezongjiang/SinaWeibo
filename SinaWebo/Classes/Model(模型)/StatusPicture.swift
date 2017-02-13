//
//  StatusPicture.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/9.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class StatusPicture: NSObject {

    var thumbnail_pic: String? {
        didSet {
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
