//
//  String+Regex.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/6/5.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

extension String {
    func href() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        guard let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else {
            print("没有匹配项目")
            return nil
        }
        
        let str = self as NSString
        
        let r1 = result.range(at: 1)
        let link = str.substring(with: r1)
        
        let r2 = result.range(at: 2)
        let text = str.substring(with: r2)
        
        return (link, text)
    }
}
