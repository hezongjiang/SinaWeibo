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
    
    @IBOutlet weak var enterBtn: UIButton!
    
    class func newFeatureView() -> NewFeatureView {
        return Bundle.main.loadNibNamed("NewFeatureView", owner: nil, options: nil)?.first as! NewFeatureView
    }
    
    @IBAction func enterBtnClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.7, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let rect = UIScreen.main.bounds
        
        let count = 4
        
        for i in 0..<count {
            
            let imageName = "new_feature_\(i + 1)"
            
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: 0)
    }
}

extension NewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        enterBtn.isHidden = scrollView.subviews.count - 1 != page
        pageControl.isHidden = scrollView.subviews.count == page
        
        pageControl.currentPage = page
    }
}
