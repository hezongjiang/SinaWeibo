//
//  NewFeatureView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/4.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class NewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    class func newFeatureView() -> NewFeatureView {
        return Bundle.main.loadNibNamed("NewFeatureView", owner: nil, options: nil)?.first as! NewFeatureView
    }
    
    @IBAction func enterBtnClick(_ sender: UIButton) {
        
    }

}


