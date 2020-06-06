//
//  Emoticon.swift
//  EmojiKeyboard
//
//  Created by bughh on 2020/5/17.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    // 发送给服务器的字符串
    @objc var chs: String?
    // 本地存储图像
    @objc var png: String?
    // emoji 字符串的编码
    @objc var code: String? {
        didSet {
            emoji = code?.emoji
        }
    }
    
    @objc var isRemoved: Bool = false
    
    // 表情使用次数
    var times = 0
    var isEmpty: Bool = false
    
    // emoji 字符串
    var emoji: String?
    
    var imagePath: String {
        if png == nil {
            return ""
        }
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }


    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init()
    }
    
    init(isRemoved: Bool) {
        self.isRemoved = isRemoved
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["chs", "png", "code", "isRemoved"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
