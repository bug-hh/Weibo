//
//  StatusCell.swift
//  Weibo
//
//  Created by bughh on 2020/5/7.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    private lazy var statusTopView: StatusCellTopView = StatusCellTopView()
    private lazy var statusLabel: UILabel = UILabel(text: "微博正文", fontSize: 15)
    private lazy var statusBottomView: StatusCellBottomView = StatusCellBottomView()
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            statusTopView.viewModel = viewModel!
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
        
        // 自动布局
        statusTopView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            // TODO 修改高度
            make.height.equalTo(60)
        }
    }
    
    
    
    
}



