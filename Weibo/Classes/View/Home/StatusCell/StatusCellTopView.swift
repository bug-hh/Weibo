//
//  StatusCellTopView.swift
//  Weibo
//
//  Created by bughh on 2020/5/7.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class StatusCellTopView: UIView {
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            nameLabel.text = viewModel?.status.user?.screen_name
            iconView.sd_setImage(with: viewModel?.userIconUrl, placeholderImage: viewModel?.defaultIconImage, options: [], context: nil)
            memberIcon.image = viewModel?.userMemberIcon
            vipIcon.image = viewModel?.userVipIcon
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    // 头像
    private lazy var iconView: UIImageView = UIImageView(imageName: "avatar_default_big")
    // 微博名
    private lazy var nameLabel: UILabel = UILabel(text: "随便", fontSize: 15)
    // 会员等级
    private lazy var memberIcon: UIImageView = UIImageView(imageName: "common_icon_membership_level6")
    // vip
    private lazy var vipIcon: UIImageView = UIImageView(imageName: "avatar_vip")
    // 微博发送时间
    private lazy var timeLabel: UILabel = UILabel(text: "刚刚", fontSize: 12, textColor: .orange)
    // 微博来源
    private lazy var sourceLabel: UILabel = UILabel(text: "HH 微博", fontSize: 12)
    
}

extension StatusCellTopView {
    private func setupUI() {
        
        let sepView = UIView()
        sepView.backgroundColor = .lightGray
        
        // 添加控件
        addSubview(sepView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memberIcon)
        addSubview(vipIcon)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 设置自动布局
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(StatusCellMargin)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(sepView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.width.equalTo(StatusCellIconWidth)
            make.height.equalTo(StatusCellIconWidth)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        
        memberIcon.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargin)
        }
        
        vipIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.right)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(StatusCellMargin / 2)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.top)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargin)
        }
    }
}
