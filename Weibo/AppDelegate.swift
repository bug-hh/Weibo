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
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        // 添加监听
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), // 通知名称，通知中心用来识别通知
                                               object: nil,   // 发送通知的对象，如果为 nil，则监听所有对象
                                               queue: nil)    // 如果为 nil，那么 queue 就用 主线程
        { [weak self] (notification) in
            let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
            self?.window?.rootViewController = vc
        }
        SQLiteManager.sharedManager
        return true
    }

    // 这个地方，可以不写，因为 AppDelegate 只有在程序完全结束的时候才调用 deinit，如果程序完全结束了，那么所有的监听也就不存在了。
    // 写得原因，是养成良好的编程习惯，有添加监听，就有移除监听
    deinit {
        // 移除监听
        NotificationCenter.default.removeObserver(self,   // 监听者
                                                  name: NSNotification.Name(WBSwitchRootViewControllerNotification),  // 监听的通知
                                                  object: nil)   // 发送通知的对象
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

extension AppDelegate {
    private var defaultRootViewController: UIViewController {
        // 先判断是否已经登录
        if UserAccountViewModel.sharedViewModel.userLogin {
            return isNewVersion ? NewFeatureViewController() : WelcomeViewController()
        }
        // 没有登录，返回主控制器
        return MainViewController()
        
    }
    
    private var isNewVersion: Bool {
        // 获取当前版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print("当前版本：\(version)")
        // 获取本地存储版本
        let sandBoxVersionKey = "SANDBOX_VERSION_KEY"
        let sandBoxVersion = UserDefaults.standard.double(forKey: sandBoxVersionKey)
        print("沙盒版本：\(sandBoxVersion)")
        // 保存当前版本
        UserDefaults.standard.set(version, forKey: sandBoxVersionKey)
        return version > sandBoxVersion
    }
}

