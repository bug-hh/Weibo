//
//  StatusCell.swift
//  Weibo
//
//  Created by bughh on 2020/5/7.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

let StatusCellMargin = 15
let StatusCellIconWidth = 35

class StatusCell: UITableViewCell {

    // 顶部视图，包含用户头像、微博等级，等等
    private lazy var statusTopView: StatusCellTopView = StatusCellTopView()
    // 微博文字
    private lazy var statusLabel: UILabel = UILabel(text: "微博正文", fontSize: 15, screenInset: CGFloat(StatusCellMargin))
    // 微博图片
    private lazy var pictureView: StatusPictureView = StatusPictureView()
    // 底部视图：转发，评论，点赞
    private lazy var statusBottomView: StatusCellBottomView = StatusCellBottomView()
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            statusTopView.viewModel = viewModel!
            statusLabel.text = viewModel?.status.text
            
            // 设置配图的 视图模型
            pictureView.viewModel = viewModel
            // 动态修改「配图视图」高度, 在指定约束后，如果控件的实际大小变了，那么就根据「控件的实际大小」更新约束
            pictureView.snp.updateConstraints { (update) in
                update.height.equalTo(pictureView.bounds.height)
                update.width.equalTo(pictureView.bounds.width)
            }
        }
        
    }
    
    // 根据给定的 view model 计算行高
    func rowHeight(vm: StatusWeiboViewModel) -> CGFloat {
        // 1、记录视图模型，赋值后，会调用上面的 didSet 设置内容以及更新'约束’
        viewModel = vm
        // 2、强制更新所有约束 -> 所有控件的 frame 都会被正确计算
        contentView.layoutIfNeeded()
        
        // 3、返回底部视图的最大高度
        return statusBottomView.frame.maxY
        
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}

// MARK: - 设置 UI
extension StatusCell {
    private func setupUI() {
        
        // 添加控件
        contentView.addSubview(statusTopView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(statusBottomView)
        
        // 自动布局
        statusTopView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            // TODO 修改高度
            make.height.equalTo( 2 * StatusCellMargin + StatusCellIconWidth)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
            make.top.equalTo(statusTopView.snp.bottom).offset(StatusCellMargin)
            // 没有指定宽度，是因为已经在构造函数里面指定了
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(statusLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
        
        statusBottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            
            // 当不再指定让 tableview 自行计算行高是，需要取得下面的约束
            // 指定向下的约束，为了给 tableview 自行计算行高用, 之所以设置 tableview 自行计算行高，是因为，微博的内容是不固定的，所以需要根据微博内容，动态调整行高
//            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    
    
    
}



