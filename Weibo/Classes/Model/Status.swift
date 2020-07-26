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
    @objc var created_at: String?
    // 微博来源
    @objc var source: String? {
        didSet {
            // 过滤出文本，并重新设置 source
            // 注意，在 didSet 内部重新给属性设置数值后，不会再次调用 didSet
            source = source?.href()?.text
        }
    }
    // 用户模型
    @objc var user: User?
    
    @objc var pic_urls:[[String: String]]?
    
    // 被转发的原微博信息字段
    @objc var retweeted_status: Status?
    
    // 每条微博的评论数
    @objc var comments_count: Int = 0
    
    // 每条微博被转发的次数
    @objc var reposts_count: Int = 0
    
    // 每条微博点赞数
    @objc var attitudes_count: Int = 0
    
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
        let keys = ["id", "text", "created_at", "source", "user", "pic_urls", "retweeted_status", "comments_count", "reposts_count", "attitudes_count"]
        
        return dictionaryWithValues(forKeys: keys).description
    }

}
