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
    
    var thumbnailUrls: [NSURL]?
    
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
        
        if let count = status.pic_urls?.count, count > 0 {
            thumbnailUrls = [NSURL]()
            for dict in status.pic_urls! {
                thumbnailUrls?.append(NSURL(string: dict["thumbnail_pic"]!)!)
            }
        }
    }
    
    override var description: String {
        return status.description + "配图数组\(thumbnailUrls ?? [])"
    }
}
