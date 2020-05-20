//
//  EmoticonAttachment.swift
//  EmojiKeyboard
//
//  Created by bughh on 2020/5/19.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    var emoticon: Emoticon
    
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageString(font: UIFont) -> NSMutableAttributedString {
        image = UIImage(contentsOfFile: emoticon.imagePath)
        // 线高，表示字的高度
        let lineHeight = font.lineHeight
        // frame = center + bounds * transform
        // bounds(x, y) = contentOffset
        // 当我们要局部设置某个控件的偏移位置时，可以改 bounds 的 x，y
        bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        
        // 获得图片文本
        let imageString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        // 给图片文本设置字体属性
        // NSFontAttributeName 在 UIKit framework 的第一个头文件中
        imageString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: 1))
        
        return imageString
    }
}
