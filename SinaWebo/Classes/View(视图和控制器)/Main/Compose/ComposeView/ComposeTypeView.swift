//
//  ComposeTypeView.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/1/16.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import pop

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
        [["title" : "文字",    "image" : "tabbar_compose_idea", "className" : "ComposeViewController"],
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
//        removeFromSuperview()
        hidenButtons()
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
        
        showView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}


// MARK: - 动画
private extension ComposeTypeView {
    
    /// 视图显示动画
    func showView() {
        
        let anim: POPBasicAnimation =  POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue   = 1
        anim.duration  = 0.3
        
        pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    /// 按钮显示动画
    func showButtons() {
        
        guard let view = scrollView.subviews.first else { return }
        
        for (i, button) in view.subviews.enumerated() {
            
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = button.center.y + 350
            anim.toValue   = button.center.y
            anim.springBounciness = 10
            anim.beginTime = CFTimeInterval(i) * 0.025 + CACurrentMediaTime()
            button.pop_add(anim, forKey: nil)
        }
    }
    
    /// 按钮隐藏动画
    func hidenButtons() {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page > scrollViewInfo.count || page < 0 { return }
        
        let view = scrollView.subviews[page]
        
        for (i, button) in view.subviews.enumerated().reversed() {
            
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = button.center.y
            anim?.toValue   = button.center.y + 350
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(view.subviews.count - i) * 0.025
            
            button.pop_add(anim, forKey: nil)
            
            if i == 1 {
                anim?.completionBlock = {(_, _) in
                    self.hidenView()
                }
            }
        }
    }
    
    
    /// 隐藏视图，然后移除
    func hidenView() {
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim?.fromValue = 1
        anim?.toValue   = 0
        anim?.duration  = 0.3
        
        pop_add(anim, forKey: nil)
        
        anim?.completionBlock = { (_, _) in
            self.removeFromSuperview()
        }
    }
    
}

// MARK: - 向scrollview中添加按钮
private extension ComposeTypeView {
    
    func setupUI() {
        
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(scrollViewInfo.count), height: 0)
        scrollView.delegate = self
        
        // 先向scrollview中添加两个view，再在每个view上添加按钮
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
                    
                } else {
                    btn.addTarget(self, action: #selector(btnClick), for: .touchDown)
                }
                btn.className = buttonInfo["className"]
                view.addSubview(btn)
            }
        }
    }
    
    /// 更多按钮点击
    @objc func clickMore() {
        
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        print("更多")
    }
    
    
    /// 按钮点击事件，展现出相应的控制器
    @objc func btnClick(selectedBtn: ComposeTypeButton) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page < 0 || page > 1 { return }
        
        let view = scrollView.subviews[page]
        
        for (i, button) in view.subviews.enumerated() {
            
            // 缩放动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            let scale = selectedBtn == button ? 1.8 : 0.5
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.8
            
            button.pop_add(scaleAnim, forKey: nil)
            
            
            // 透明度变化动画
            let alphaAnim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim?.toValue = 0.2
            alphaAnim?.duration = 0.4
            
            button.pop_add(alphaAnim, forKey: nil)
            
            if i == 0 {
                alphaAnim?.completionBlock = { _, _ in
                    
                    guard let className = selectedBtn.className,
                        let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else { return }
                    
                    let nav = UINavigationController(rootViewController: cls.init())
                    UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: {
                        self.removeFromSuperview()
                    })
                }
            }
        }
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
