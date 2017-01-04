//
//  WelcomeView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/4.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import SDWebImage

class WelcomeView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView() -> WelcomeView {
        
        return Bundle.main.loadNibNamed("WelcomeView", owner: nil, options: nil)?.first as! WelcomeView
//        return UINib(nibName: "WelcomeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! WelcomeView
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        guard let urlString = NetworkManager.shared.userAccount.avatar_large, let url = URL(string: urlString) else {
            return
        }
        
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
    }

    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            
            self.layoutIfNeeded()
            
        }) {(_) in
            
            UIView.animate(withDuration: 1, animations: { 
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                
                UIView.animate(withDuration: 1, animations: { self.alpha = 0 }, completion: { (_) in self.removeFromSuperview() })
                
            })
        }
        
    }
}
