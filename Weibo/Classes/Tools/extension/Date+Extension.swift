//
//  Date+Extension.swift
//  Weibo
//
//  Created by bughh on 2020/6/5.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

extension Date {
    static func sinaDate(str: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
       
        return df.date(from: str)
    }
    
    // 返回当前日期的描述信息  (计算型属性）
    /*
     刚刚（一分钟内）
     X 分钟前（一小时内）
     X 小时前（当天）
     昨天 HH:mm （昨天）
     MM-dd HH:mm （一年内）
     yyyy-MM-dd HH:mm（更早期）
     */
    var dateDescription: String {
        // 取出当前日历 - 提供了大量的日历相关的操作函数
        let calendar = Calendar.current
        
        // 处理今天的日期
        if calendar.isDateInToday(self) {
            let interval = Int(Date().timeIntervalSince(self))
//            print("interval: \(interval)")
            if interval < 60 {
                return "刚刚"
            } else if interval < 3600 {
                return "\(interval / 60) 分钟前"
            }
            
            return "\(interval / 3600) 小时前"
        }
        
        // 非今天的日期
        var fmt = "HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天 " + fmt
        } else {
            // 一年内
            fmt = "MM-dd " + fmt
            // 直接获取 「年」的数值
            //        print(calendar.component(.year, from: self))
                    
            // 相当于 用 self - to 得到的差值
            let result = calendar.compare(self, to: Date(), toGranularity: .year)
//            print("*************   \(result.rawValue)")
            if result.rawValue < 0 {
                fmt = "yyyy-" + fmt
            }
        }
        
        let df = DateFormatter()
        df.dateFormat = fmt
        df.locale = Locale(identifier: "en")

        return df.string(from: self)
    }
}
