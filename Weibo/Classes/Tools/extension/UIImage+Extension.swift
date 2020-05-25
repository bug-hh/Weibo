//
//  UIImage+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/5/24.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension UIImage {
    /*
     将图像缩放到指定的宽度
     return： 如果给定的图片的宽度小于指定的宽度，直接返回
     */
    func scaleToWith(width: CGFloat) -> UIImage {
        if width > size.width {
            return self
        }
        
        // 计算比例
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 使用核心绘图绘制新的图像
        // 开启绘图上下文
        UIGraphicsBeginImageContext(rect.size)
        
        // 绘图，在指定的区域拉伸绘制
        self.draw(in: rect)
        // 取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        // 返回结果
        return result!
    }
}
