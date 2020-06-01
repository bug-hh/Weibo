//
//  StatusDAL.swift
//  Weibo
//
//  Created by bughh on 2020/6/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

// 数据访问层，专门负责处理本地 sqlite 和网络数据
class StatusDAL {
    
    class func loadStatus() {
        // 1、检查本地是否有缓存
        
        // 2、如果有，则返回缓存数据
        // 3、如果没有，加载网络数据
        // 4、将网络返回的数据，保存在本地数据库，以便后续使用
        // 5、返回网络数据
        
    }
    
    // 将网络返回的数据，保存在本地数据库
    class func saveCacheData(arr: [[String: Any?]]) {
        guard let userId = UserAccountViewModel.sharedViewModel.userAccount?.uid else {
            print("用户未登录")
            return
        }
        
        // 准备 sql
        let sql = "INSERT OR replace INTO T_Status (statusId, status, userId) VALUES (?, ?, ?);"
        
        SQLiteManager.sharedManager.queue.inTransaction { (db, rollBack) in
            for dict in arr {
                // 微博 id
                let statusId = dict["id"] as! Int
                // 序列化字典 -> 二进制数据
                let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                // 插入数据
                do {
                    try db.executeUpdate(sql, values: [statusId, json, userId])
                } catch {
                    print("插入数据失败")
                    rollBack.pointee = true
                    break
                    
                }
            }
        }
        print("数据插入完成")
    }
}
