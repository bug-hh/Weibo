//
//  UILabel+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/4/29.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, screenInset: CGFloat) {
        self.init()
        self.text = text
        self.textColor = textColor
        // 设置文字多行显示
        self.numberOfLines = 0
        if screenInset == 0 {
            self.textAlignment = .center
        } else {
            self.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset
            self.textAlignment = .left
        }
        
    }
    
    convenience init(text: String, fontSize: CGFloat = 14, textColor: UIColor = .darkGray, screenInset: CGFloat = 0) {
        self.init(text: text, textColor: textColor, screenInset: screenInset)
        self.font = UIFont.systemFont(ofSize: fontSize)
        
    }
}
