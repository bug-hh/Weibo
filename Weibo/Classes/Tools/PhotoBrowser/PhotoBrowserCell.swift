//
//  PhotoBrowserCellCollectionViewCell.swift
//  Weibo
//
//  Created by bughh on 2020/5/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var imageView: UIImageView = UIImageView()
    
    // http://wx3.sinaimg.cn/thumbnail/006x0M7Agy1gf4ldi9jm8j31900u04qr.jpg 缩略图
    // https://open.weibo.com/wiki/2/statuses/home_timeline  文档地址
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else {
                return
            }
            
            // 当大图网络加载较慢时，先从从磁盘加载缩略图，放置在中心
            imageView.image = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString)
            // 设置大小
            imageView.sizeToFit()
            // 设置中心点
            imageView.center = scrollView.center
            
            // 异步加载大图
            imageView.sd_setImage(with: bmiddleUrl(url: url)) { (image, _, _, _) in
                self.imageView.center = CGPoint.zero
                self.imageView.sizeToFit()
            }
        }
    }
    
    private func bmiddleUrl(url: URL) -> URL {
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: urlString)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加控件
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        
        // 定义布局
        scrollView.frame = bounds
        scrollView.backgroundColor = .yellow
    }
    
}
