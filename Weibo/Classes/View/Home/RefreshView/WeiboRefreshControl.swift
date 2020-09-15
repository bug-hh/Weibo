//
//  WeiboRefreshControl.swift
//  Weibo
//
//  Created by bughh on 2020/5/15.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

private let WeiBoRefreshControlOffset: CGFloat = -60

class WeiboRefreshControl: UIRefreshControl {
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startLoading()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoading()
        
    }
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: -  KVO 监听方法
    /*
     这个 UIRefreshControl 一直待在屏幕上
     下拉的时候，frame 的 y 一直变小，向上推的时候，y 变大
     y 默认为 0
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        
        // 判断是否正在刷新
        if isRefreshing {
            refreshView.startLoading()
            return
        }
        
        if frame.origin.y < WeiBoRefreshControlOffset && !refreshView.rotateFlag {
//            print("反过来")
            refreshView.rotateFlag = true
        } else if frame.origin.y >= WeiBoRefreshControlOffset && refreshView.rotateFlag {
//            print("转过去")
            refreshView.rotateFlag = false
        }
    }
    
    private func setupUI() {
        tintColor = .clear
        addSubview(refreshView)
        // 从 xib 加载的控件，需要指定大小约束
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
        
        // 使用 KVO 监听位置变化, 主队列，当主线程有任务时，就不调度队列中的任务执行
        /*
         在当前运行循环中所有代码执行完毕后，运行循环结束前，开始监听
         方法触发会在下一次运行循环开始
         */
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
        
    }
    
    deinit {
        // 移除 KVO 监听方法
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    private lazy var refreshView = WeiboRefreshView.refreshView()
}

class WeiboRefreshView: UIView {
    class func refreshView() -> WeiboRefreshView {
        let nib = UINib(nibName: "WeiboRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WeiboRefreshView
    }
    
    // 旋转下拉箭头动画
    private func rotateIcon() {
        var angle = CGFloat(Double.pi)
        angle += rotateFlag ? -0.000001 : 0.000001
        // 旋转动画，特点：顺时针优先 + 就近原则
        UIView.animate(withDuration: 0.5) {
            self.arrowIconView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    // 刷新加载动画
    func startLoading() {
        arrowView.isHidden = true
        
        // 判断动画是否已经加载
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        print("开始加载动画")
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        // 防止切换页面，再返回时，动画消失
        anim.isRemovedOnCompletion = false
        
        loadingIconView.layer.add(anim, forKey: key)
    }
    
    func stopLoading() {
        arrowView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
        
    }
    
    @IBOutlet weak var loadingIconView: UIImageView!
    
    @IBOutlet weak var arrowView: UIView!
    
    @IBOutlet weak var arrowIconView: UIImageView!
    var rotateFlag = false {
        didSet {
            rotateIcon()
        }
    }
    
    
    
}
