//
//  ComposeTypeView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/16.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ComposeTypeView: UIView {

    
    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 返回按钮
    @IBOutlet weak var returenButton: UIButton!
    
    /// 关闭按钮中心点约束
    @IBOutlet weak var closeBtnCenterXCons: NSLayoutConstraint!
    
    /// 返回按钮中心点约束
    @IBOutlet weak var returenBtnCenterXCons: NSLayoutConstraint!
    
    fileprivate let scrollViewInfo = [
        [["title" : "文字",    "image" : "tabbar_compose_idea"],
         ["title" : "照片/视频","image" : "tabbar_compose_photo"],
         ["title" : "长微博",  "image" : "tabbar_compose_weibo"],
         ["title" : "签到",    "image" : "tabbar_compose_lbs"],
         ["title" : "点评",    "image" : "tabbar_compose_review"],
         ["title" : "更多",    "image" : "tabbar_compose_more", "actionName" : "clickMore"]],
        
        [["title" : "好友圈",   "image" : "tabbar_compose_friend"],
         ["title" : "微博相机", "image" : "tabbar_compose_camera"],
         ["title" : "音乐",    "image" : "tabbar_compose_music"],
         ["title" : "拍摄",    "image" : "tabbar_compose_shooting"]]
        
    ]
    
    /// 关闭界面
    @IBAction func close() {
        removeFromSuperview()
    }
    
    /// 返回第一页
    @IBAction func returenClick() {
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    class func composeTypeView() -> ComposeTypeView {
        let view = Bundle.main.loadNibNamed("ComposeTypeView", owner: nil, options: nil)?.first as! ComposeTypeView
        view.frame = UIScreen.main.bounds
        
        view.setupUI()
        return view
    }
    
    func show() {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        vc.view.addSubview(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}

private extension ComposeTypeView {
    
    func setupUI() {
        
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(scrollViewInfo.count), height: 0)
        scrollView.delegate = self
        
        // 向scrollview中添加两个view，每个view上添加按钮
        for (i, viewInfo) in scrollViewInfo.enumerated() {
            
            let view = UIView(frame: CGRect(x: CGFloat(i) * rect.width, y: 0, width: rect.width, height: rect.height))
            
            scrollView.addSubview(view)
            
            /// 按钮的宽度
            let btnWidth = view.bounds.width / 3
            
            /// 按钮的高度
            let btnHeight = view.bounds.height / 2
            
            for (j, buttonInfo) in viewInfo.enumerated() {
                
                guard let title = buttonInfo["title"], let image = buttonInfo["image"] else { continue }
                
                let btn = ComposeTypeButton.composeTypeButton(title: title, image: image)
                
                let row = CGFloat(j / 3)
                let col = CGFloat(j % 3)
                
                btn.frame = CGRect(x: col * btnWidth, y: row * btnHeight, width: btnWidth, height: btnHeight)
                if let clickMore = buttonInfo["actionName"] {
                    
                    btn.addTarget(self, action: Selector(clickMore), for: .touchUpInside)
                }
                view.addSubview(btn)
            }
        }
    }
    
    /// 更多按钮点击
    @objc func clickMore() {
        
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        print("更多")
    }
    
    @objc func btnClick() {
        print("按钮被点击")
    }
}

// MARK:- UIScrollViewDelegate
extension ComposeTypeView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x / scrollView.bounds.width
        
        if offsetX > 1 || offsetX < 0 { return }
        
        returenButton.alpha = offsetX
        
        let margin = scrollView.bounds.width / 6 * offsetX
        
        closeBtnCenterXCons.constant = margin
        returenBtnCenterXCons.constant = -margin
    }
}
