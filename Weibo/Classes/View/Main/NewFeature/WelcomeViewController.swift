//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by bughh on 2020/5/3.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    override func loadView() {
        view = backgroundImageView
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // multipliy 属性是只读属性，创建以后，不允许修改,因为之后要改位置，所以用 offset 属性替代
        /*
            使用自动布局开发，有一个原则：
            所有使用约束设置位置的控件，不要在设置 `frame`
            原因：自动布局系统会根据设置的约束，自动计算控件的 frame，同时在 layoutSubviews 中设置 frame，
            如果程序员主动修改 frame，会引起自动布局系统计算错误
         
            工作原理：当有一个运行循环启动，自动布局系统会`收集`所有的约束变化，
            在运行循环结束前，调用 layoutSubviews 方法，统一设置 frame
            如果希望某些约束提前更新，使用 `layoutIfNeeded` 函数让自动布局系统，提前更新当前收集到的约束变化
         */
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 200)
        }
        
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.8) {
                self.welcomeLabel.alpha = 1
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private lazy var backgroundImageView: UIImageView = UIImageView(imageName: "ad_background")
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(imageName: "avatar_default_big")
//        设置圆角
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()

    private lazy var welcomeLabel:UILabel = UILabel(text: "欢迎归来", fontSize: 18)
}


// MARK - 设置界面
extension WelcomeViewController {
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            // multipliy 属性是只读属性，创建以后，不允许修改,因为之后要改位置，所以用 offset 属性替代
//            make.bottom.equalTo(view.snp.bottom).multipliedBy(0.7)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
        
    }
}
