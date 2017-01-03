//
//  AppDelegate.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit
import UserNotifications

let UserShouldLoginNotification = "UserShouldLoginNotification"
let AppKey = "3716276687"
let RedirectUrl = "https://www.baidu.com/"
let AppSecret = "eea50bc9928d4c6bdc967816f895368c"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
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
}

