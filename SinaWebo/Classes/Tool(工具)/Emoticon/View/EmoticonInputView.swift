//
//  EmoticonInputView.swift
//  keyboard
//
//  Created by Hearsay on 2017/1/24.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

private let cellId = "cellId"

/// 表情键盘
class EmoticonInputView: UIView {
    
    /// 表情视图
    @IBOutlet weak var collectionView: UICollectionView!

    /// 底部工具栏
    @IBOutlet weak var toolBar: UIView!
    
    class func inputView() -> EmoticonInputView {
        
        let nib = UINib(nibName: "EmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil).first as! EmoticonInputView
        return v
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension EmoticonInputView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return EmoticonManager.manager.emotiPackages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonManager.manager.emotiPackages[section].numberOfPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EmoticonCell
        cell.emoticons = EmoticonManager.manager.emotiPackages[indexPath.section].emoticon(page: indexPath.item)
        return cell
    }
}
