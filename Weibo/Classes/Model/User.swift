//
//  User.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

class User: NSObject {
    @objc var id: Int = 0
    @objc var screen_name: String?
    @objc var profile_image_url: String?
    @objc var verified_type: Int = 0
    @objc var mbRank: Int = 0
    
    init(dict: [String: Any?]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
    
    override var description: String {
        let keys = ["id", "screen_name", "profile_image_url", "verified_type"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
