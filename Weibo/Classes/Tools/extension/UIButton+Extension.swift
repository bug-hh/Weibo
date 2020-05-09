//
//  UIButton+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/4/27.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UIButton {
    /// 便利构造函数
    convenience init(imageName: String, backgroundImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: .highlighted)
        // 根据背景图片自动调整大小
        sizeToFit()
    }
    
    convenience init(backgroundImageName: String, title: String, color: UIColor) {
        self.init()
        setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        sizeToFit()
    }
    
    convenience init(foregroundImageName: String, title: String, fontSize: CGFloat = 12) {
        self.init()
        setImage(UIImage(named: foregroundImageName), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(.darkGray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}


