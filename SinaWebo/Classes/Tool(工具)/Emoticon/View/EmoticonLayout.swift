//
//  EmoticonLayout.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/24.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

/// 表情键盘每一页的布局
class EmoticonLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.bounds.size
        
    }
}
