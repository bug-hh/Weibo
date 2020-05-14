//
//  StatusListViewModel.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation
import SDWebImage

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
                arrayList.append(s)
            }
            self.cacheSinglePicture(dataList: arrayList)
            self.statusList = arrayList + self.statusList
            finish(true)
        }
    }
    
    // 缓存单张图片
    private func cacheSinglePicture(dataList: [StatusWeiboViewModel]) {
        // 创建 group
        let group = DispatchGroup()
        // 缓存数据的长度
        var dataLength = 0
        
        for vm in dataList {
            if vm.thumbnailUrls?.count != 1 {
                continue
            }
            
            let url = vm.thumbnailUrls![0]
            print("开始缓存图片 \(url)")
            // 入组，监听后续的闭包
            group.enter()
            
            // SDWebImage - 下载图像（缓存是自动完成的），如果本地缓存已经存在，同样会通过完成回调返回
            // 只有当 缓存图像大小较小时，才能用这种方式缓存
            SDWebImageManager.shared.loadImage(with: url as URL, options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], progress: nil) { (image, _, _, _, _, _) in
                // 单张图片下载完成
                if let img = image {
                    let data = UIImage.pngData(img)
                    dataLength += data()!.count
                    
                }
                
                // 出组, 注意出组和入组要成对出现
                group.leave()
            }
        }
        
        // 监听调度组完成
        group.notify(queue: DispatchQueue.main) {
            // 这个缓存的长度，包含本地缓存图像
            print("缓存完成 \(dataLength)")
        }
        
    }
}
