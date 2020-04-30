//
//  MainViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加控制器，并不会添加 tabbar 中的按钮，因为控件时懒加载的，所有控件都是延迟创建的
        addChildViewControllers()
//        print(tabBar.subviews)
        setUpComposedButton()
    }
    
    /*
     响应「按钮点击事件」本质上还是由 oc 发送消息事件给某个方法，所以在前面加上 @objc 的标记，代表这个函数会被 oc 调用
     如果不加 @objc，只加了 private，那么当点击按钮后，由于这个方法是私有的，那么会造成消息循环找不到对应的方法，而崩溃
     */
    @objc private func composedButtonClicked() {
        print("点击")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 会创建 tabbar 中所有控制器对应的按钮
        super.viewWillAppear(animated)
        // 将撰写的按钮放在最前面
        tabBar.bringSubviewToFront(composedButton)
    }
    //  MARK: - 懒加载控件
    private lazy var composedButton: UIButton = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
}


// MARK: - 设置界面
extension MainViewController {
    
    private func setUpComposedButton() {
        // 1、添加按钮
        tabBar.addSubview(composedButton)
        // 2、调整按钮的位置
        let count = children.count
        // 算出每个底部按钮的宽度
        let w = tabBar.bounds.width / CGFloat(count)
        let h = tabBar.bounds.height
        
        composedButton.frame = CGRect(x: 2 * w, y: 0, width: w, height: h)
        composedButton.addTarget(self, action: #selector(self.composedButtonClicked), for: .touchUpInside)
        print(composedButton.frame)
    }
    
    private func addChildViewControllers() {
        // 设置 tintColor - 图片渲染颜色, 如果在 AppDelegate 里设置了全局渲染，那么这里就不用渲染了
        // 性能提升技巧 - 如果能用颜色解决，就不建议使用图片
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChild(UIViewController())
        addChildViewController(vc: DiscoveryTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
    }
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        // 设置标题 - 由内至外设置的
        vc.title = title
        
        // 设置图像
        vc.tabBarItem.image = UIImage(named: imageName)
        
        // 导航控制器
        let nav = UINavigationController(rootViewController: vc)
        
        addChild(nav)
    }
}
