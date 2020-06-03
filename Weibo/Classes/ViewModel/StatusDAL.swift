//
//  StatusDAL.swift
//  Weibo
//
//  Created by bughh on 2020/6/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

private let maxCacheDateTime: TimeInterval = 60 // 7 * 24 * 60 * 60

// 数据访问层，专门负责处理本地 sqlite 和网络数据
class StatusDAL {
    
    class func clearDataCache() {
        let date = Date(timeIntervalSinceNow: maxCacheDateTime)
        // 日期格式转换
        let df = DateFormatter()
        // 指定区域 - 在模拟器上不需要，但是真机一定需要
        df.locale = Locale(identifier: "en")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateStr = df.string(from: date)
        print(dateStr)
        
        //执行 sql
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        
        SQLiteManager.sharedManager.queue.inTransaction { (db, rollback) in
            if db.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                print("删除了 \(db.changes) 条缓存数据")
            }
        }
    }
    
    class func loadStatus(since_id: Int, max_id: Int, finish: @escaping ([[String: Any]]?) -> ()) {
        // 1、检查本地是否有缓存
        let arr = checkCacheData(since_id: since_id, max_id: max_id)
        
        // 2、如果有，则返回缓存数据
        if arr?.count ?? 0 > 0 {
            print("查询到本地缓存数据")
            finish(arr)
            return
        }
        
        // 3、如果没有，加载网络数据
        NetTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) in
            if error != nil {
                finish(nil)
                return
            }
            
            let resultDict = result as? [String: Any?]
            guard let array = resultDict?["statuses"] as? [[String: Any?]] else {
                finish(nil)
                return
            }
            
            // 4、将网络返回的数据，保存在本地数据库，以便后续使用
            StatusDAL.saveCacheData(arr: array)
            
            // 5、返回网络数据
            finish(array)
        }
    }
    
    // 检查本地是否有数据库缓存数据
    private class func checkCacheData(since_id: Int, max_id: Int) -> [[String: Any]]? {
        print("检查本地数据 \(since_id)  \(max_id)")
        
        guard let userId = UserAccountViewModel.sharedViewModel.userAccount?.uid else {
            print("用户未登录")
            return nil
        }
        
        var sql = "SELECT statusId, status, userId \n"
        sql += "FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        if since_id > 0 { // 下拉刷新
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 { // 上拉刷新
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        
        let arr = SQLiteManager.sharedManager.execRecordSet(sql: sql)
        var arrayM = [[String: Any]]()
        for dict in arr {
            let jsonData = dict["status"] as! Data
            // 反序列化  -> 拿到一条完整微博数据字典
            let result = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            arrayM.append(result as! [String : Any])
        }
        
        return arrayM
    }
    
    // 将网络返回的数据，保存在本地数据库
    private class func saveCacheData(arr: [[String: Any?]]) {
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
