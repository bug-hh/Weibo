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
        if let rank = status.user?.mbRank, rank >= 0 && rank < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user?.mbRank ?? 1)")
        }
        return nil
    }
    
    init(status: Status) {
        self.status = status
    }
}
