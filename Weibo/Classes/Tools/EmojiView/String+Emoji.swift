//
//  String+Emoji.swift
//  EmojiString
//
//  Created by bughh on 2020/5/17.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

extension String {
    var emoji: String {
        // 文本扫描器 - 扫描指定格式的字符串
        let scanner = Scanner(string: self)

        // unicode 值
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)


        // 转换 unicode 字符
        let chr = Character(Unicode.Scalar(value)!)

        // 转换成 字符串
        return "\(chr)"
    }
}
