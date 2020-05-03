//
//  UILabel+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/4/29.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor) {
        self.init()
        self.text = text
        self.textColor = textColor
        // 设置文字多行显示
        self.numberOfLines = 0
        self.textAlignment = .center
    }
    
    convenience init(text: String, fontSize: CGFloat = 14, textColor: UIColor = .darkGray) {
        self.init(text: text, textColor: textColor)
        self.font = UIFont.systemFont(ofSize: fontSize)
    }
}
