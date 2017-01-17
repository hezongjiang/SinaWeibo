//
//  AppDelegate.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UserNotifications
import SVProgressHUD
import AFNetworking



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        setupAddition()
        
        return true
    }

    private func loadAppInfo() {
        
        DispatchQueue.global().async {
            
            let url = Bundle.main.url(forResource: "main", withExtension: "json")
            
            let data = NSData(contentsOf: url!)
            
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath = (docPath as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: filePath, atomically: true)
            
        }
    }
    
    
    /// 设置额外信息
    private func setupAddition() {
        
        // 设置指示器最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
//        SVProgressHUD.setDefaultMaskType(.gradient)
        // 设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}

