//
//  MainTabBarController.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    lazy var composeBtn:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupChildController()
        
        setupComposeBtn()
    }
    
    /// 撰写按钮
    private func setupComposeBtn() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            
            self.tabBar.addSubview(self.composeBtn)
            self.composeBtn.center = CGPoint(x: self.tabBar.bounds.width * 0.5, y: self.tabBar.bounds.height * 0.5)
            self.composeBtn.addTarget(self, action: #selector(self.composeStatus), for: .touchUpInside)
            self.tabBar.bringSubview(toFront: self.composeBtn)
        }
        
    }
    
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
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else {
            return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tabbar_" + image)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + image + "_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orange], for: .highlighted)
        let nav = MainNavViewController(rootViewController: vc)
        
        
        return nav
    }
    
    
}
