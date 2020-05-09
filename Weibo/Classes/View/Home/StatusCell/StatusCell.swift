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

    private lazy var statusTopView: StatusCellTopView = StatusCellTopView()
    private lazy var statusLabel: UILabel = UILabel(text: "微博正文", fontSize: 15, screenInset: CGFloat(StatusCellMargin))
    private lazy var statusBottomView: StatusCellBottomView = StatusCellBottomView()
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            statusTopView.viewModel = viewModel!
            statusLabel.text = viewModel?.status.text
        }
        
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
        
        statusBottomView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            
            // 指定向下的约束，为了给 tableview 自行计算行高用, 之所以设置 tableview 自行计算行高，是因为，微博的内容是不固定的，所以需要根据微博内容，动态调整行高
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    
    
    
}



