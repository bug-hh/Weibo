//
//  AppDelegate.swift
//  Weibo
//
//  Created by bughh on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        setupAppearance()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WelcomeViewController()
        window?.makeKeyAndVisible()
        return true
    }

    // 设置全局外观，在很多应用程序中，都会在 AppDelegate 中设置所有控件的全局外观
    private func setupAppearance() {
//        修改导航栏的全局外观，要在控件创建之前设置，一经设置，全局有效
        UINavigationBar.appearance().tintColor = .orange
        UITabBar.appearance().tintColor = .orange
    }
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

