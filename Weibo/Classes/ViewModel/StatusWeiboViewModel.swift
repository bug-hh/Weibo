//
//  StatusWeiboViewModel.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation


// 用于处理单条微博的业务逻辑
class StatusWeiboViewModel: NSObject {
    var status: Status
    
    init(status: Status) {
        self.status = status
    }
}
