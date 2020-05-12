//
//  StatusWeiboViewModel.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit


// 用于处理单条微博的业务逻辑
class StatusWeiboViewModel: NSObject {
    var status: Status
    
    lazy var rowHeight: CGFloat = {
        // 获取 cell
        print("计算行高 \(self.status.text ?? "")")
        let cell = StatusRetweetedCell(style: .default, reuseIdentifier: StatusRetweetedCellID)
        return cell.rowHeight(vm: self)
    }()
    
    var userIconUrl: URL? {
        return URL(string: status.user?.profile_image_url ?? "")
    }
    
    var defaultIconImage: UIImage {
        return UIImage(named: "avatar_default_big")!
    }
    
    var userMemberIcon: UIImage? {
        if let rank = status.user?.mbrank, rank >= 0 && rank < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user?.mbrank ?? 1)")
        }
        return nil
    }
    
    /*
     缩略图 URL 数组 - 存储型属性
     如果是原创微博，可以有图，可以没有图
     如果是转发微博，一定没有图，retweeted_status 中，可以有图，也可以没有图
     一条微博，最多只有一个 pic_urls 数组
     */
    var thumbnailUrls: [NSURL]?
    
    var retweetedText: String? {
        guard let s = status.retweeted_status else {
            return nil
        }
        let text1 = "@" + (s.user?.screen_name ?? "") + ": "
        let text2 = s.text ?? ""
        return text1 + text2
        
    }
    
    //  -1 未认证用户  0 认证用户  2，3，5 企业认证  220 达人
    var userVipIcon: UIImage? {
        switch status.user?.verified_type ?? -1 {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:  //
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
        
    }
    init(status: Status) {
        self.status = status
        
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnailUrls = [NSURL]()
            for dict in urls {
                thumbnailUrls?.append(NSURL(string: dict["thumbnail_pic"]!)!)
            }
        }
    }
    
    override var description: String {
        return status.description + "配图数组\(thumbnailUrls ?? [])"
    }
}
