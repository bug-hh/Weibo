//
//  AppDelegate.swift
//  Weibo
//
//  Created by bughh on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate {

    var window: UIWindow?

    func applicationDidEnterBackground(_ application: UIApplication) {
        // 清除数据库缓存
        StatusDAL.clearDataCache()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(appKey)
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        // 设置 AFN - 当通过 AFN 发起网络请求是，会在状态栏显示菊花
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
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

// MARK: - WeiboSDKDelegate
extension AppDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response .isKind(of: WBAuthorizeResponse.self) {
            print("接收到 weibo SSO 授权响应")
            let res = response as! WBAuthorizeResponse
            let dt: [String: Any?] = ["access_token": res.accessToken,
                      "expireDate": res.expirationDate,
                      "uid": res.userID]
            print(res.userID)
            let userAccount = UserAccount(dict: dt as [String : Any])
            UserAccountViewModel.sharedViewModel.userAccount = userAccount
            UserAccountViewModel.sharedViewModel.loadUserInfo(userAccount: userAccount) { (isSuccessed: Bool) in
                if !isSuccessed {
                    print("获取 user info 失败")
                    SVProgressHUD.showInfo(withStatus: "获取 user info 失败")
                    return
                }

                // 关闭指示器
                SVProgressHUD.dismiss()
                // 登录完成以后，同时在销毁 OAuthViewController 以后，才发送通知，将控制器换成 newfeature viewcontroller
                // 通知中心是同步的，一旦发送通知，会先执行监听方法，结束后，才继续往后执行
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification),
                object: "welcome")

            }
        }
    }
}

// MARK: - 处理「微博客户端」调起本应用
extension AppDelegate {
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: self)
    }
    
    
}

