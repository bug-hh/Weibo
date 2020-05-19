//
//  ComposeViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/19.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        print("发送微博")
    }
    override func loadView() {
        super.loadView()
        setupUI()
    }

}

// 设置界面
extension ComposeViewController {
    private func setupUI() {
        //设置背景颜色
        view.backgroundColor = .white
        // 设置导航栏
        prepareNavigationBar()
        
    }
    
    private func prepareNavigationBar() {
        // 左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(send))
        
        // 中间标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        // 添加 title view 的子控件
        let titleLabel = UILabel(text: "发微博", fontSize: 15, textColor: .darkGray, screenInset: 0)
        let nameLabel = UILabel(text: UserAccountViewModel.sharedViewModel.userAccount?.screenName ?? "", fontSize: 13, textColor: .lightGray, screenInset: 0)
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        
        // 添加自动布局
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.bottom.equalTo(titleView.snp.bottom)
        }
    }
}
