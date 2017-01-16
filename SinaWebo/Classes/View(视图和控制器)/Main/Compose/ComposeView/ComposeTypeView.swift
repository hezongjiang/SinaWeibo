//
//  ComposeTypeView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/16.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeTypeView: UIView {

    class func composeTypeView() -> ComposeTypeView {
        let view = Bundle.main.loadNibNamed("ComposeTypeView", owner: nil, options: nil)?.first as! ComposeTypeView
        view.frame = UIScreen.main.bounds
        
        return view
    }
    
    func show() {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        vc.view.addSubview(self)
    }
}
