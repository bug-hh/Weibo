//
//  UIImageView+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/4/29.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(imageName: String) {
        self.init()
        self.image = UIImage(named: imageName)
    }
}
