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
            let size = CGSize(width: 150, height: 90)
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
    private lazy var iconView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        // 当使用上面这种模式时，一定要记得「裁剪图片」
        iv.clipsToBounds = true
        return iv
    }()
    
    var imageUrl: NSURL? {
        didSet {
            iconView.sd_setImage(with: imageUrl as URL?, placeholderImage: nil, options: [.retryFailed,  // SDWebImage 超时时长为 15s，一旦超时，则计入黑名单，加入这个选项后，则不会加入嘿名单
                                                                                  .refreshCached]) // 当服务器 url 没变，但是 url 所指图像变化时，会重新下载图片
                                 
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
        // 设置自动布局, 因为 cell 会变化，不同的cell 大小可能不一样
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        
    }
}
