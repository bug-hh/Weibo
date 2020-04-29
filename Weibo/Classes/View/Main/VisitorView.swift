//
//  VisitorView.swift
//  Weibo
//
//  Created by bughh on 2020/4/28.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit


protocol VisitorDelegate: NSObjectProtocol {
    func register()
    func login()
}

class VisitorView: UIView {

    weak var delegate: VisitorDelegate?
    
    // MARK:  - 开启首页动画
    func startAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        
        // 用在不断重复的动画上，当动画绑定的图层对应的视图销毁时，动画会自动释放
        anim.isRemovedOnCompletion = false
        
        iconImageView.layer.add(anim, forKey: nil)
    }
    
    func setUpInfo(imageName: String?, text: String) {
        // 如果 imageName 为 nil，表示的是首页的访客界面
        guard let imgName = imageName else {
            startAnim()
            return
        }
        iconImageView.image = UIImage(named: imgName)
        textLabel.text = text
        // 非首页，隐藏掉房子图片
        homeImageView.isHidden = true
        // 把首页遮罩放到最底下
        sendSubviewToBack(maskImageView)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private lazy var iconImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    private lazy var maskImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    private lazy var homeImageView = UIImageView(imageName: "visitordiscover_feed_image_house")
    private lazy var textLabel: UILabel = UILabel(text: "关注一些人，回这里看看有什么惊喜", textColor: .darkGray)
    private lazy var registerButton: UIButton = UIButton(imageName: "common_button_white_disable", title: "注册", color: .orange)
    private lazy var loginButton: UIButton = UIButton(imageName: "common_button_white_disable", title: "登录", color: .darkGray)
    
    private func setupUI() {
        // 添加子控件
        addSubview(iconImageView)
        addSubview(maskImageView)
        addSubview(homeImageView)
        addSubview(textLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 设置自动布局
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 设置圆圈
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -60))
        
        // 设置小房子
        addConstraint(NSLayoutConstraint(item: homeImageView, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeImageView, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        // 设置文字
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1.0, constant: 36))
        // 要设置 label 的宽度，同时不要设置高度，这样当文字比较长的时候，文字才会换行
        // 如果设置了高度，那么当文字过长是，就只能显示一部分文字
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300))
//        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        
        // 设置注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: textLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        
        
        // 设置登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: textLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        
        
        // 设置遮罩
        /**   VFL: 可视化格式语言
               H    水平方向
               V    垂直方向
                |  边界
               []   包装控件
                views   是一个字典, [名字: 控件名}    VFL  字符串中表示控件的字符串
                metrics   是一个字典，[名字：NSNumber]   VFL  字符串中表示某一个数值
         */
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mask]-0-|", options: [], metrics: nil, views: ["mask": maskImageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mask]-(btnHeight)-[regButton]", options: [], metrics: ["btnHeight": -40], views: ["mask": maskImageView, "regButton": registerButton]))
        
        
        // 设置背景颜色   - 灰度图  R G B, 在 UI 元素中，大多数都使用灰度图，或者纯色图（安全图）
        // 237 怎么来的？  通过「数码测色计」得出
        backgroundColor = UIColor(white: 237 / 255.0, alpha: 1.0)
        
        registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    
    @objc func registerButtonClicked() {
        delegate?.register()
    }
    
    @objc func loginButtonClicked() {
        delegate?.login()
    }
}


