//
//  UIColor+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/5/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
}
