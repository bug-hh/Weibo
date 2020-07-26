//
//  StatusCellBottomView.swift
//  Weibo
//
//  Created by bughh on 2020/5/7.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var retweetButton: UIButton = UIButton(foregroundImageName: "timeline_icon_retweet", title: " 转发")
    private lazy var commentButton: UIButton = UIButton(foregroundImageName: "timeline_icon_comment", title: " 评论")
    private lazy var likeButton: UIButton = UIButton(foregroundImageName: "timeline_icon_unlike", title: " 赞")
    
    var viewModel: StatusWeiboViewModel? {
        didSet {
            guard let vm = viewModel else {
                print("为空")
                retweetButton.titleLabel?.text = "转发"
                commentButton.titleLabel?.text = "评论"
                likeButton.titleLabel?.text = "赞"
                return
            }
            print("点赞数: \(vm.status.attitudes_count)")
            retweetButton.titleLabel?.text = "\(self.recalculate(num: vm.status.reposts_count))"
            commentButton.titleLabel?.text = "\(self.recalculate(num:vm.status.comments_count))"
            likeButton.titleLabel?.text = "\(self.recalculate(num:vm.status.attitudes_count))"
        }
    }
    
    /*
     0 < num < 1000 return "num"
     1000 < num < 10000 return "\(num / 1000)k"
     10000 < num  return "\(num / 10000)万"
     */
    private func recalculate(num: Int) -> String {
        if num > 0 && num < 1000 {
            return "\(num)"
        } else if num >= 1000 && num < 10000 {
            return "\(num / 1000)k"
        } else {
            return "\(num / 10000)万"
        }
    }
    
}

// MARK: - 设置布局
extension StatusCellBottomView {
    private func setupUI() {
        // 设置背景颜色
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        // 添加控件
        addSubview(retweetButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        
        // 设置自动布局
        retweetButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetButton.snp.top)
            make.left.equalTo(retweetButton.snp.right)
            make.width.equalTo(retweetButton.snp.width)
            make.height.equalTo(retweetButton.snp.height)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.width.equalTo(commentButton.snp.width)
            make.height.equalTo(commentButton.snp.height)
            
            make.right.equalTo(self.snp.right)
        }
        
        // 添加分割线
        let sp1 = sepView()
        let sp2 = sepView()
        
        addSubview(sp1)
        addSubview(sp2)
        
        let sepWidth = 0.5
        let sepScale = 0.4
        
        // 添加自动布局
        sp1.snp.makeConstraints { (make) in
            make.left.equalTo(retweetButton.snp.right)
            make.centerY.equalTo(retweetButton.snp.centerY)
            make.width.equalTo(sepWidth)
            make.height.equalTo(retweetButton.snp.height).multipliedBy(sepScale)
        }
        
        sp2.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(retweetButton.snp.centerY)
            make.width.equalTo(sepWidth)
            make.height.equalTo(retweetButton.snp.height).multipliedBy(sepScale)
        }
        
    }
    
    private func sepView() -> UIView {
        let ret = UIView()
        return ret
    }
}
