//
//  SQLiteManager.swift
//  HH-FMDB
//
//  Created by 彭豪辉 on 2020/5/29.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import Foundation


private let dbName = "status.db"

class SQLiteManager {
    static let sharedManager = SQLiteManager()
    
    let queue: FMDatabaseQueue
    
    private init() {
        // 数据库路径
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        print(path)
        // 打开数据库队列
        queue = FMDatabaseQueue(path: path)!
        createTalbe()
    }
    
    private func createTalbe() {
        // 准备 sql
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        
        // 执行 sql
        queue.inDatabase { (db) in
            if db.executeStatements(sql) {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
    }
    
}
