//
//  Status.swift
//  Weibo
//
//  Created by bughh on 2020/5/4.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class Status: NSObject {
    // 微博 ID
    @objc var id: Int = 0
    // 微博内容
    @objc var text: String?
    // 微博创建时间
    @objc var create_at: String?
    // 微博来源
    @objc var source: String?
    // 用户模型
    @objc var user: User?
    
    @objc var pic_urls:[[String: String]]?
    
    // 被转发的原微博信息字段
    @objc var retweeted_status: Status?
    
    init(dict: [String: Any?]) {
        super.init()
        // 如果使用 KVC, 如果 value 是一个字典，那么会将对应属性，直接转换成字典
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // 将 user 单独拿出来处理，不让 KVC 将其变成字典
        if key == "user", let dict = value as? [String: Any?] {
            user = User(dict: dict)
            return
        }
        
        if key == "retweeted_status", let dict = value as? [String: Any?] {
            retweeted_status = Status(dict: dict)
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override var description: String {
        let keys = ["id", "text", "create_at", "source", "user", "pic_urls", "retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }

}
