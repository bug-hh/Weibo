//
//  UserAccountViewModel.swift
//  Weibo
//
//  Created by bughh on 2020/5/2.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

class UserAccountViewModel {
    var userAccount: UserAccount?
    
    private var accountPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).strings(byAppendingPaths: ["account.plist"]).last!
    }
    init() {
        userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        print(userAccount)
    }
}
