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
            self.cacheSinglePicture(dataList: arrayList, finish: finish)
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
            /*
             SDWebImage 的核心下载函数，如果本地缓存已经存在，同样会通过完成回调返回
             如果设置了 SDWebImageOptions.retryFailed，如果下载失败，block 会结束一次，会做一次出组。
             然后 SDWebImage 再次尝试下载，下载完成后，再次调用闭包中的代码，「再次调用出组函数」，造成调度组不匹配，引起崩溃
             SDWebImageOptions.refreshCached，第一次发起网络请求，把缓存的图片的 hash 值发送给服务器，
             服务器对比 hash 值，如果和服务器内容一致，返回状态码 304，表示服务器内容没有变化
             如果不是 304，则 SDWebImage 会再次发起网络请求,获得更新后的内容(这个和 retryFailed）是一致的
             */
            SDWebImageManager.shared.loadImage(with: url as URL, options: [], progress: nil) { (image, _, _, _, _, _) in
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
