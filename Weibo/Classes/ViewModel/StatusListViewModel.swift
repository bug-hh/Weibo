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
    
    /**
         加载微博数据
       * parameter isPullup   是否上拉刷新
       * parameter finish  回调函数
    */
    func loadStatus(isPullup: Bool, finish: @escaping (_ isSuccessed: Bool) -> ()) {
        
        // 微博最上面的 内容是最新的，也就是返回的第一条微博是最新的
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) : 0
        
        NetTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) in
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
            // 如果是下拉刷新，那么将最新的数据拼接在最前面
            if since_id > 0 {
                self.statusList = arrayList + self.statusList
            } else { // 如果是上拉刷新，那么把之前的数据放在后面
                self.statusList += arrayList
            }
            
            finish(true)
            // 当缓存图片总量过大时，会崩溃，原因不明，暂时先不使用缓存图片的功能
//            self.cacheSinglePicture(dataList: arrayList, finish: finish)
        }
    }
    
    // 缓存单张图片
    private func cacheSinglePicture(dataList: [StatusWeiboViewModel], finish: @escaping (_ isSuccessed: Bool) -> ()) {
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
            finish(true)
        }
        
    }
}
