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
    
    private lazy var emojiView: EmojiView = EmojiView { [weak self] (emoticon) in
        self?.textView.insertEmoticon(em: emoticon)
    }

    private lazy var toolBar: UIToolbar = UIToolbar()
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = .darkGray
        
        // 向下拖拽 textview 时，收起键盘
        tv.keyboardDismissMode = .onDrag
        // 始终允许垂直滚动
        tv.bounces = true
        tv.alwaysBounceVertical = true
        return tv
    }()
    
    private lazy var placeHolderLabel = UILabel(text: "分享新鲜事...", fontSize: 18, textColor: .lightGray, screenInset: 0)
    
    @objc func close() {
        // 先关闭键盘
        textView.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        print("发送微博")
    }
    
    @objc func emojiClick() {
        print("表情 click")
        // 1、退掉键盘
        textView.resignFirstResponder()
        
        // 2、更换键盘，如果弹出的是系统键盘，那么 inputView 为 nil
        textView.inputView = textView.inputView == nil ? emojiView : nil
        
        // 3、唤起键盘
        textView.becomeFirstResponder()
        
    }
    
    @objc func keyboardChanged(n: Notification) {
//        for (k, v) in n.userInfo! {
//            print("\(k)   \(v)")
//        }
        // 获取键盘的高度, OC 中字典中的结构体会包装成 NSValue，数值会包装成 NSNumber
        // "UIKeyboardFrameEndUserInfoKey"): NSRect: {{0, 550}, {414, 346}}
        let rect = (n.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let duration = (n.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
        let curve = (n.userInfo!["UIKeyboardAnimationCurveUserInfoKey"] as! NSNumber).intValue
        
        let offSet = -UIScreen.main.bounds.height + rect.origin.y
        
        // 更新 tool bar 的约束
        toolBar.snp.updateConstraints { (update) in
            update.bottom.equalTo(view.snp.bottom).offset(offSet)
        }
        
        // UIView 块动画，本质上是对 CAAnimation 的包装
        UIView.animate(withDuration: duration) {
            // 设置动画曲线
            /*
             设置曲线值为 7，
                如果之前的动画没有完成，又启动了其他的动画，让动画的图层直接运动到后续动画的目标位置
                一旦设置了 7，动画时长无效，动画时长统一变成 0.5s
             */
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
            // 更新约束
            self.view.layoutIfNeeded()
        }
        
        // 调试动画时长
//        let anim = toolBar.layer.animation(forKey: "position")
//        print("动画时长：\(anim?.duration)")
        
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(n:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        // 当用户进入「发微博」的界面后，第一时间把键盘弹出来
        textView.becomeFirstResponder()
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
