//
//  StatusRetweetedCell.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/12.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import FFLabel
//let StatusRetweetedCellID = "StatusRetweetedCellID"

class StatusRetweetedCell: StatusCell {
    
    /*
     微博模型视图
     如果继承父类的属性
     1、需要 override
     2、不需要显示调用 super
     3、自动先执行父类的 didSet，在执行子类的 didSet
     */
    override var viewModel: StatusWeiboViewModel? {
        didSet {
            retweetedLabel.text = viewModel?.retweetedText
            // 设置配图的 视图模型
            pictureView.viewModel = viewModel
            // 动态修改「配图视图」高度, 在指定约束后，如果控件的实际大小变了，那么就根据「控件的实际大小」更新约束
            pictureView.snp.updateConstraints { (update) in
                // 根据配图数量，决定配图视图顶部间距
                let offset = (viewModel?.thumbnailUrls ?? []).count > 0 ? StatusCellMargin : 0
                update.top.equalTo(self.retweetedLabel.snp.bottom).offset(offset)
            }
            
        }
    }
    // MARK: - 懒加载控件
    // 背景按钮
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return button
    }()

    // 转发标签
    private lazy var retweetedLabel: FFLabel = {
        let label = FFLabel(text: "转发微博", fontSize: 14, textColor: .darkGray, screenInset: CGFloat(StatusCellMargin))
        return label
    }()
    
}

extension StatusRetweetedCell {
    override func setupUI() {
        super.setupUI()
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(statusBottomView.snp.top)
        }
        
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { (make) in
             make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
             make.left.equalTo(retweetedLabel.snp.left)
             make.width.equalTo(300)
             make.height.equalTo(90)
        }
        
        retweetedLabel.labelDelegate = self
    }
}

