//
//  UIBarButtonItem+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/5/20.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, target: Any?, actionName: String?) {
        let button = UIButton(imageName: imageName, backgroundImageName: nil)
        if let actionName = actionName {
            button.addTarget(target, action: Selector(actionName), for: .touchUpInside)
        }
        
        self.init(customView: button)
    }
}
