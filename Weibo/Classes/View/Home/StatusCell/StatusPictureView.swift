//
//  StatusPictureView.swift
//  Weibo
//
//  Created by bughh on 2020/5/11.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

//照片之间的间距
let StatusPictureViewItemMargin = 8

// 配图视图
class StatusPictureView: UICollectionView {
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
           sizeToFit()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let itemWidth = (maxWidth - 2 * StatusPictureViewItemMargin) / rowCount
        
        // 2、设置 layout 的 itemSize
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
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
            let w = 2 * itemWidth + StatusPictureViewItemMargin
            return CGSize(width: w, height: w)
        }
        
        // 其他数量的图片，按照 九宫格 显示
        let row = (count - 1) / rowCount + 1
        let w = rowCount * itemWidth + (rowCount - 1) * StatusPictureViewItemMargin
        let h = row * itemWidth + (row - 1) * StatusPictureViewItemMargin
        return CGSize(width: w, height: h)
    }
    
}
