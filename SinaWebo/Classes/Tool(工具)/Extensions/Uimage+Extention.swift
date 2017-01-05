
//
//  Uimage+Extention.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/5.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

extension UIImage {
    
    func avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 0. 开启图形上下午
        UIGraphicsBeginImageContextWithOptions(size!, true, 0)
        
        // 1. 设置背景颜色填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 2. 画一个圆形路径
        let path = UIBezierPath(ovalIn: rect)
        
        // 3. 沿路径裁剪
        path.addClip()
        
        // 4. 画
        draw(in: rect)
        
        // 5. 设置边线
        lineColor.setStroke()
        path.lineWidth = 1
        path.stroke()
        
        // 6. 取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7. 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return result
    }
}
