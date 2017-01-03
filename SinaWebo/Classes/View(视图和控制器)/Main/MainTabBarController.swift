//
//  MainTabBarController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var timer: Timer?
    
    lazy var composeBtn:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildController()
        
        setupComposeBtn()
        
        delegate = self
        
        //setupTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
    }
    
    @objc private func userLogin() {
        
        let nav = UINavigationController(rootViewController: OAuthViewController())
        
        present(nav, animated: true, completion: nil)
    }
    
    /// 设置定时器，检查微博未读数
    private func setupTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateUnreadCount), userInfo: nil, repeats: true)
        
    }
    
    /// 检查微博未读数
    @objc private func updateUnreadCount() {
        
        if !NetworkManager.shared.userLogin {
            return
        }
        
        NetworkManager.shared.unreadCount { (count) in
            
            // 设置首页未读数
            self.tabBar.items?.first?.badgeValue = count > 0 ? "\(count)" : nil
            
            // 设置应用程序未读数，iOS8 开始需要授权
            UIApplication.shared.applicationIconBadgeNumber = count
            
            print("微博未读数" + "\(count)")
        }
    }
    
    /// 撰写按钮
    private func setupComposeBtn() {
        
        self.tabBar.addSubview(self.composeBtn)
        self.composeBtn.center = CGPoint(x: self.tabBar.bounds.width * 0.5, y: self.tabBar.bounds.height * 0.5)
        self.composeBtn.addTarget(self, action: #selector(self.composeStatus), for: .touchUpInside)
    }
    
    /// 发布微博
    @objc private func composeStatus() {
        print("发布微博")
    }
    
    /// 添加自控制器
    private func setupChildController() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (path as NSString).appendingPathComponent("main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        
        if data == nil {
            
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            
            data = NSData(contentsOfFile: path!)
            
        }
        
        guard let dicts = try? JSONSerialization.jsonObject(with: (data as! Data), options: []) as? [[String : AnyObject]] else {
            return
        }
        
        for dict in dicts! {
            
            addChildViewController(controller(dict: dict))
        }
        
        
    }
    
    /// 通过字典创建导航控制器
    private func controller(dict: [String : AnyObject]) -> UIViewController {
        
        guard let className = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let image = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? BaseViewController.Type,
            let visitorInfo = dict["visitorInfo"] as? [String : String]
        
        else {
            return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.visitorInfo = visitorInfo
        vc.tabBarItem.image = UIImage(named: "tabbar_" + image)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + image + "_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: .selected)
        let nav = MainNavViewController(rootViewController: vc)
        
        
        return nav
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        timer?.invalidate()
    }
    
//    https://api.weibo.com/oauth2/authorize
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = childViewControllers.index(of: viewController)
        
        if index == 0 && index == selectedIndex {
            
            let nav = childViewControllers.first as? UINavigationController
            let vc = nav?.childViewControllers.first as? HomeViewController
            
            vc?.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                vc?.loadData()
            })
            
            print("重复点击首页")
        }
        
        return true
    }
}
