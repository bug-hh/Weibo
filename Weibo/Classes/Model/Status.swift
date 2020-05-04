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
    
    init(dict: [String: Any?]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["id", "text", "create_at", "source"]
        return dictionaryWithValues(forKeys: keys).description
    }

}
