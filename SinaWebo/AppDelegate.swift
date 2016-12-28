//
//  AppDelegate.swift
//  SinaWebo
//
//  Created by Hearsay on 2016/12/26.
//  Copyright © 2016年 Hearsay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadAppInfo()
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
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

