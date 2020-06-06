//
//  EmoticonViewModel.swift
//  EmojiKeyboard
//
//  Created by bughh on 2020/5/17.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

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
    
    func emoticonText(string: String, font: UIFont) -> NSAttributedString {
        let strM = NSMutableAttributedString(string: string)
        let pattern = "\\[.*?\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        // 匹配多项内容
        let result = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        var count = result.count
        
        while count > 0 {
            count -= 1
            let range = result[count].range(at: 0)
            // 从字符串中取出表情子串
            let emStr = (string as NSString).substring(with: range)
            // 根据 emStr 查找对应的表情模型
            if let em = emoticonWithString(string: emStr) {
                // 根据 em 生成一个图片属性文本
                let attrText = EmoticonAttachment(emoticon: em).imageString(font: font)
                // 替换属性字符串中的内容
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
        return strM
    }
    
    // 根据表情字符串，在表情包中查找对应表情
    func emoticonWithString(string: String) -> Emoticon? {
        for package in packages {
            /*
             过滤表情包数组，找出 em.chs == string 的表情模型
             如果闭包有返回值，且闭包代码只有一句，可以省略 return
             如果有参数，参数可以使用 $0,$1,$2 替代
             $0 对应的就是数组中的元素
             */
            if let emoticon = package.emoticons.filter({ $0.chs == string }).last {
                return emoticon
            }
        }
        return nil
    }
}
