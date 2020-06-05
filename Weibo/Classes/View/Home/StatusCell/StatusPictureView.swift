//
//  StatusPictureView.swift
//  Weibo
//
//  Created by bughh on 2020/5/11.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SDWebImage
//照片之间的间距
let StatusPictureViewItemMargin: CGFloat = 8
let StatusPictureViewID = "StatusPictureViewID"

// 配图视图
class StatusPictureView: UICollectionView {
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            sizeToFit()
            // 刷新数据，如果不刷新，后续的 collectionview 一旦被复用，不再调用数据源方法
            reloadData()
        }
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    // MARK: - 构造函数
    init() {
        // 一定要加上 flow layout
        let layout = UICollectionViewFlowLayout()
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        // 灰度图
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        //  设置数据源
        //  应用场景：自定义视图的小框架
        dataSource = self
        delegate = self
        // 注册可重用 cell
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureViewID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 实现 UICollectionView 数据源方法
extension StatusPictureView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPictureViewID, for: indexPath) as! StatusPictureViewCell
        cell.imageUrl = viewModel?.thumbnailUrls![indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StatusPictureView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MARK: - 测试展现动画函数
//        photoBrowserPresentFromRect(indexPath: indexPath)
//        photoBrowserPresentToRect(indexPath: indexPath)
        let userInfo = [WBStatusSelectedPhotoIndexPathKey: indexPath, WBStatusSelectedPhotoURLsKey: viewModel!.thumbnailUrls!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(WBStatusSelectedPhotoNotification),
                                        object: self,
                                        userInfo: userInfo)
        
    }
}

// MARK: - 计算视图大小
extension StatusPictureView {
    private func calcViewSize() -> CGSize {
        // 1、准备
        // 每行照片的数量
        let rowCount = 3
        // 每行照片的最大宽度
        let maxWidth = Int(UIScreen.main.bounds.width) - 2 * StatusCellMargin
        // 一张图片的宽度
        let itemWidth = (maxWidth - 2 * Int(StatusPictureViewItemMargin)) / rowCount
        
        // 2、设置 layout 的 itemSize
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = StatusPictureViewItemMargin
        layout.minimumLineSpacing = StatusPictureViewItemMargin
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // 3、获取配图数量
        let count = viewModel?.thumbnailUrls?.count ?? 0
        
        // 计算应该返回的「配图视图」宽和高
        // 微博没有配图
        if count == 0 {
            return CGSize.zero
        }
        
        // 一张图片
        if count == 1 {
            // 先临时指定
            var size = CGSize(width: 150, height: 90)
            // 利用 SDWebImage 拿到磁盘缓存图像
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString,
                let image = SDImageCache.shared.imageFromDiskCache(forKey: key) {
                size = image.size
            }
            
            // 过窄处理，针对长图
            size.width = size.width < 40 ? 40 : size.width
            // 过宽处理，对于过宽的图片，同样，图片的高度也肯定是超的，所以需要等比例缩放
            if size.width > 300 {
                let w: CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            
            layout.itemSize = size
            return size
        }
        
        // 4 张图片, 应该返回一个 2 * 2 的布局
        if count == 4 {
            let w = 2 * itemWidth + Int(StatusPictureViewItemMargin)
            return CGSize(width: w, height: w)
        }
        
        // 其他数量的图片，按照 九宫格 显示
        let row = (count - 1) / rowCount + 1
        let w = rowCount * itemWidth + (rowCount - 1) * Int(StatusPictureViewItemMargin)
        let h = row * itemWidth + (row - 1) * Int(StatusPictureViewItemMargin)
        return CGSize(width: w, height: h)
    }
    
}

private class StatusPictureViewCell: UICollectionViewCell {
    //  提示图片是否为 GIF
    private lazy var gifIconView: UIImageView = UIImageView(imageName: "timeline_image_gif")
    
    private lazy var iconView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        // 当使用上面这种模式时，一定要记得「裁剪图片」
        iv.clipsToBounds = true
        return iv
    }()
    
    var imageUrl: NSURL? {
        didSet {
            iconView.sd_setImage(with: imageUrl as URL?,
                                 placeholderImage: nil,
                                 options: [.retryFailed,  // SDWebImage 超时时长为 15s，一旦超时，则计入黑名单，加入这个选项后，则不会加入嘿名单
                                .refreshCached]) // 当服务器 url 没变，但是 url 所指图像变化时，会重新下载图片
            let ext = ((imageUrl?.absoluteString ?? "") as NSString).pathExtension.lowercased()
            gifIconView.isHidden = ext != "gif"
                                 
        }
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
        contentView.addSubview(iconView)
        iconView.addSubview(gifIconView)
        
        // 设置自动布局, 因为 cell 会变化，不同的cell 大小可能不一样
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        
        gifIconView.snp.makeConstraints { (make) in
            make.right.equalTo(iconView.snp.right)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        
    }
}

// MARK: - 照片查看器展现协议
extension StatusPictureView: PhotoBrowserPresentDelegate {
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView {
        let iv = UIImageView()
        // 设置图像填充模式
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // 设置图像（使用缩略图缓存）SDWebImage 如果本地有缓存，则不会发起网络请求
        if let url = viewModel?.thumbnailUrls?[indexPath.item] {
            iv.sd_setImage(with: url as URL, completed: nil)
        }
        
        return iv
    }
    
    // 动画起始位置
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect {
        let cell = cellForItem(at: indexPath)!
        
        /*
         通过 cell 相对于 collection view 的位置，计算出 cell 相对于屏幕的位置
         在不同视图之间的「坐标系转换」
         */
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        // 测试 rect 的位置
//        let v = imageViewForPresent(indexPath: indexPath)
//        v.frame = rect
//        UIApplication.shared.keyWindow!.addSubview(v)
        
        return rect
    }
    
    // 动画目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        // 根据缩略图大小，等比例计算目标位置
        // 获取缩略图的key
        guard let key = viewModel?.thumbnailUrls?[indexPath.item].absoluteString else {
            return CGRect.zero
        }
        // SDWebImage 获取本地缓存图片
        guard let image = SDImageCache.shared.imageFromDiskCache(forKey: key) else {
            return CGRect.zero
        }
        
        // 根据图片大小，计算全屏图像大小
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        var y: CGFloat = 0
        // 图片过短，垂直居中显示
        let screenHeight = UIScreen.main.bounds.height
        if h < screenHeight {
            y = (screenHeight - h) * 0.5
        }
        
        let rect = CGRect(x: 0, y: y, width: w, height: h)
        // 测试 rect 的位置
//        let v = imageViewForPresent(indexPath: indexPath)
//        v.frame = rect
//        UIApplication.shared.keyWindow!.addSubview(v)
        return rect
    }
    
    
}
