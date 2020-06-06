//
//  EmoticonViewModel.swift
//  EmojiKeyboard
//
//  Created by bughh on 2020/5/17.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import Foundation

/**
 * 读取 Emoticons.bundle 中的 emoticons.plist
 */
class EmoticonManager {
    static let sharedManager = EmoticonManager()
    
    lazy var packages = [EmoticonPackage]()
    
    // MARK: - 最近表情
    // 添加最近表情到 package[0] 的表情数组中
    func addRecent(em: Emoticon) {
        em.times += 1
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.insert(em, at: 0)
            
            // 删除倒数第二个表情
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        // 按照使用次数排序
//        packages[0].emoticons.sort { (em1, em2) -> Bool in
//            em1.times > em2.times
//        }
        packages[0].emoticons.sort { $0.times > $1.times }
        
    }
    
    private init() {
        // 添加最近分组
        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近分组"]))
        // 加载 emoticon.plist
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 加载字典
        let dict = NSDictionary(contentsOfFile: path) as! [String: Any]
        // 提取字典中 id 对应的 value 值
        let arr = (dict["packages"] as! NSArray).value(forKey: "id") as! [String]
        
        // 遍历 id 数组，准备加载每组中的 info.plist
        for id in arr {
            loadInfoPlist(id: id)
        }
//        print(packages)
    }
    
    private func loadInfoPlist(id: String) {
        let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        let dict = NSDictionary(contentsOfFile: path) as! [String: Any]
        
        packages.append(EmoticonPackage(dict: dict))
        
    }
}
