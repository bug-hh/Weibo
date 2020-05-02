//
//  UserAccount.swift
//  Weibo
//
//  Created by bughh on 2020/5/2.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    // 由于使用 KVC 给属性赋值，底层实现中，这些属性会被 OC 调用，所以一定要加上 @objc 属性，不然，属性值无法被设置，都为 nil
    @objc var access_token: String?
    // access_token 的过期时间，单位是秒
    // 一旦从服务器获得时间，立马计算准确的日期
    @objc var expires_in: TimeInterval = 0 {
        // 这个在 OC 里面，就是重写 expires_in 属性的 set 方法
        didSet {
            expireDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    @objc var remind_in: TimeInterval = 0
    @objc var uid: String?
    @objc var expireDate: NSDate?
    @objc var screenName: String?
    @objc var avatarLarge: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["access_token", "expireDate", "remind_in", "uid", "screenName", "avatarLarge"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    func saveUserAccount() {
        // 这个路径一定存在，所以，可以强行解包
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).strings(byAppendingPaths: ["account.plist"]).last!
        // 保存完文件以后，一定要确认一下，文件确实保存了
        print(path)
        NSKeyedArchiver.archiveRootObject(self, toFile: path)
    }
    
    // `required` 没有继承性，所有的对象只能解档出当前的类对象
    required init?(coder: NSCoder) {
        access_token =  coder.decodeObject(forKey: "access_token") as? String
        expireDate = coder.decodeObject(forKey: "expireDate") as? NSDate
        uid = coder.decodeObject(forKey: "uid") as? String
        screenName = coder.decodeObject(forKey: "screenName") as? String
        avatarLarge = coder.decodeObject(forKey: "avatarLarge") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expireDate, forKey: "expireDate")
        coder.encode(uid, forKey: "uid")
        coder.encode(screenName, forKey: "screenName")
        coder.encode(avatarLarge, forKey: "avatarLarge")
    }
}
