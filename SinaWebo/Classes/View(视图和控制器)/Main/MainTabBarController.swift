//
//  MainTabBarController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import SVProgressHUD

class MainTabBarController: UITabBarController {
    
    private var timer: Timer?
    
    lazy var composeBtn:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildController()
        
        setupComposeBtn()
        
        delegate = self
        
        // 设置定时器，定时检查微博未读数
        setupTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
    }
    
    // 登录通知方法
    @objc private func userLogin(noti: Notification) {
        
        var when = DispatchTime.now()
        
        if noti.object != nil {
            
            when = DispatchTime.now() + 2
            
            SVProgressHUD.showInfo(withStatus: "登录过期")
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            let nav = UINavigationController(rootViewController: OAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    /// 设置定时器，检查微博未读数
    private func setupTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(updateUnreadCount), userInfo: nil, repeats: true)
        
    }
    
    /// 检查微博未读数
    @objc private func updateUnreadCount() {
        
        // 如果没有登录，不检查未读数
        if !NetworkManager.shared.userLogin { return }
        
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
    
    /// 添加子控制器
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
