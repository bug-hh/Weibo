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
            
            // 恢复 scrollview，保证上一张图片的缩放，不会影响下一张图片的显示
            resetScrollView()
            
            // 当大图网络加载较慢时，先从从磁盘加载缩略图，放置在中心
            imageView.image = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString)
            // 设置大小
            imageView.sizeToFit()
            // 设置中心点
            imageView.center = scrollView.center
            
            // 异步加载大图
            imageView.sd_setImage(with: bmiddleUrl(url: url)) { (image, _, _, _) in
                self.setPosition(image: image!)
            }
        }
    }
    
    // 重设 scrollview 内容属性
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    private func setPosition(image:UIImage) {
        let size = self.displaySize(image: image)
        if size.height < scrollView.bounds.height {
            let y = (scrollView.bounds.height - size.height) * 0.5
            // 调整内容边距, 会调整控件的位置，但不会影响控件滚动
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
            // 调整 frame 的 x/y，一旦缩放，影响滚动范围
            imageView.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
        
    }
    
    // 返回根据 scrollview 的宽度等比例缩放后的图片尺寸
    private func displaySize(image: UIImage) -> CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
        
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
        var rect = bounds
        // 给图片与图片之间留出边距
        rect.size.width -= 20
        scrollView.frame = rect
//        scrollView.backgroundColor = .yellow
        
        // 设置 scrollview 的缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
    }
    
}

extension PhotoBrowserCell: UIScrollViewDelegate {
    // 返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 该方法在缩放完成后执行一次
    // view: 被缩放的视图
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("缩放完成")
        
        var offSetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offSetY = offSetY < 0 ? 0 : offSetY
        
        var offSetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offSetX = offSetX < 0 ? 0 : offSetX
        scrollView.contentInset = UIEdgeInsets(top: offSetY, left: offSetX, bottom: 0, right: 0)
        
    }
}
