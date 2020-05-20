//
//  UITextView+Emoticon.swift
//  EmojiKeyboard
//
//  Created by 彭豪辉 on 2020/5/19.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

extension UITextView {
    func insertEmoticon(em: Emoticon) {
        // 空白表情
        if em.isEmpty {
            return
        }
        
        // 删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        
        // emoji
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        
        insertImageEmoticon(em: em)
    }
    
    func insertImageEmoticon(em: Emoticon) {
        // 获取图片属性文本
        let imageString = EmoticonAttachment(emoticon: em).imageString(font: font!)
        
        // 将 textView 原有内容转换成 可变内容
        let strM = NSMutableAttributedString(attributedString: attributedText)
        
        // 插入图片文本
        strM.replaceCharacters(in: selectedRange, with: imageString)
        
        // 记住光标位置
        let range = selectedRange
        // 替换文本
        attributedText = strM
        // 恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
    
    var emoticonText: String {
        let attrText = attributedText
        var strM = String()
        // 遍历属性文本
        attrText?.enumerateAttributes(in: NSRange(location: 0, length: attrText!.length), options: [], using: { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key(rawValue: "NSAttachment")] as? EmoticonAttachment {
                strM.append(attachment.emoticon.chs ?? "")
            } else {
                let str = (attrText!.string as NSString).substring(with: range)
                strM.append(str)
            }
        })
        return strM
    }
}
