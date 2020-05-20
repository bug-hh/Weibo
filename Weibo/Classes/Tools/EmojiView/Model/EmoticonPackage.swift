//
//  EmoticonPackage.swift
//  EmojiKeyboard
//
//  Created by bughh on 2020/5/17.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

// MARK: - 表情包数组
class EmoticonPackage: NSObject {
    // 表情包所在分组
    @objc var id: String?
    // 表情包组名，显示在 toolbar 上
    @objc var group_name_cn: String?
    // 表情包数组
    @objc lazy var emoticons = [Emoticon]()
    
    init(dict: [String: Any]) {
        super.init()
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        
        if let dictList = dict["emoticons"] as? [[String: Any]] {
            var index = 0
            for var dict in dictList {
                if let p = dict["png"] as? String, let dir = id {
                    dict["png"] = dir + "/" + p
                }
                emoticons.append(Emoticon(dict: dict))
                index += 1
                if index == 39 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        appendEmptyEmoticon()
        
    }
    
    // 对于不足一页的，添加空白按钮补充
    private func appendEmptyEmoticon() {
        let count = emoticons.count % 40
        for _ in count..<39 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        // 在这一页末尾，添加一个删除按钮
        emoticons.append(Emoticon(isRemoved: true))
    }
    
    override var description: String {
        let keys = ["id", "group_name_cn", "emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
    

}
