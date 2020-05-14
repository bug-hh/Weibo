//
//  StatusNormalCell.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/14.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {
    
    override var viewModel: StatusWeiboViewModel? {
        didSet {
            // 动态修改「配图视图」高度, 在指定约束后，如果控件的实际大小变了，那么就根据「控件的实际大小」更新约束
            pictureView.snp.updateConstraints { (update) in
                // 根据配图数量，决定配图视图顶部间距
                let offset = (viewModel?.thumbnailUrls ?? []).count > 0 ? StatusCellMargin : 0
                update.top.equalTo(self.statusLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(statusLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
}
