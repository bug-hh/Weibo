//
//  UserAccountViewModel.swift
//  Weibo
//
//  Created by bughh on 2020/5/2.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

class UserAccountViewModel {
    
    static let sharedViewModel = UserAccountViewModel()
    
    var userAccount: UserAccount?
    
    // 返回有效的 token
    var accessToken: String? {
        if !isExpire {
            return self.userAccount?.access_token
        }
        return nil
    }
    
    // 用户头像的 URL
    var avatarURL: NSURL {
        return NSURL(string: self.userAccount?.avatarLarge ?? "")!
    }
    
    private var accountPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).strings(byAppendingPaths: ["account.plist"]).last!
    }
    
    var userLogin: Bool {
        return userAccount?.access_token != nil && !isExpire
    }
    
    private var isExpire: Bool {
        // 测试
//        userAccount?.expireDate = NSDate(timeIntervalSinceNow: -3600)
        if userAccount?.expireDate?.compare(NSDate() as Date) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    
    private init() {
        userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        //  如果过期了，就清空
        if isExpire {
            print("用户信息已经过期")
            userAccount = nil
        }
    }
    
    func loadAccessToken(code: String, finish: @escaping (_ isSuccessed: Bool) -> ()) {
        NetTools.sharedTools.accessToken(code: String(code)) { (result, error) in
            if error != nil {
                finish(false)
                print("1111111")
                return
            }
            
            // result 是 Any? 类型，所以一定要使用 as? 或者 as!
            self.userAccount = UserAccount(dict: result as! [String: Any])
            // 在闭包里，调用实例方法是，一定要加上 self
            self.loadUserInfo(userAccount: self.userAccount!, finish: finish)
        }
        print("NetTools accessToken")
    }
    
    private func loadUserInfo(userAccount: UserAccount, finish: @escaping (_ isSuccessed: Bool) -> ()) {
        NetTools.sharedTools.loadUserInfo(uid: userAccount.uid!) { (result, error) in
            if error != nil {
                finish(false)
                return
            }
            
            // 如果使用 if/let 或 guard/let 通透使用 as?   [String: Any] 可以换成 NSDictionary
            guard let dict = result as? [String: Any] else {
                finish(false)
                return
            }
            
            self.userAccount?.screenName = dict["screen_name"] as? String
            self.userAccount?.avatarLarge = dict["avatar_large"] as? String
            print(self.accountPath)
            NSKeyedArchiver.archiveRootObject(self.userAccount!, toFile: self.accountPath)
            finish(true)
        }
        
    }
    
    
}
