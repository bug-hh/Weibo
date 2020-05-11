//
//  StatusListViewModel.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

class StatusListViewModel {
    lazy var statusList = [StatusWeiboViewModel]()
    
    func loadStatus(finish: @escaping (_ isSuccessed: Bool) -> ()) {
        NetTools.sharedTools.loadStatus { (result, error) in
            if error != nil {
                finish(false)
                return
            }
            
            let resultDict = result as? [String: Any?]
            guard let array = resultDict?["statuses"] as? [[String: Any?]] else {
                finish(false)
                return
            }
            
            var arrayList = [StatusWeiboViewModel]()
            for dict in array {
                let s = StatusWeiboViewModel(status: Status(dict: dict))
                print(s)
                arrayList.append(s)
            }
            
            self.statusList = arrayList + self.statusList
            finish(true)
        }
    }
}
