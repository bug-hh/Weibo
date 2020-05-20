//
//  ComposeViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/19.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SnapKit

class ComposeViewController: UIViewController {

    private lazy var toolBar: UIToolbar = UIToolbar()
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = .darkGray
        // 始终允许垂直滚动
        tv.bounces = true
        tv.alwaysBounceVertical = true
        return tv
    }()
    
    private lazy var placeHolderLabel = UILabel(text: "分享新鲜事...", fontSize: 18, textColor: .lightGray, screenInset: 0)
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        print("发送微博")
    }
    
    @objc func emojiClick() {
        print("表情 click")
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
        // 设置工具栏
        prepareToolbar()
        // 设置文本输入框
        prepareTextView()
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
    
    private func prepareToolbar() {
        view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(64)
        }
        
        let itemSettings = [
            ["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "actionName": "emojiClick"],
            ["imageName": "compose_add_background"]
        ]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["actionName"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
    private func prepareTextView() {
        view.addSubview(textView)
        let height = self.navigationController?.navigationBar.frame.maxY
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top).offset(height!)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        textView.text = "分享新鲜事..."
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textView.snp.left).offset(6)
            make.top.equalTo(textView.snp.top).offset(8)
        }
    }
}
