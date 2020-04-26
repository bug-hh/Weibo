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

        // Do any additional setup after loading the view.
        addChildViewControllers()
    }
    
    //  MARK: - 懒加载控件
    private lazy var composedButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        return button
    }()

}


// MARK: - 设置界面
extension MainViewController {
    
    private func setUpComposedButton() {
        
        
        
    }
    private func addChildViewControllers() {
        // 设置 tintColor - 图片渲染颜色
        // 性能提升技巧 - 如果能用颜色解决，就不建议使用图片
        tabBar.tintColor = UIColor.orange
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(vc: UIViewController(), title: "", imageName: "")
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
