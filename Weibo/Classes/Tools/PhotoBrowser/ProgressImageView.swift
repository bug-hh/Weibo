//
//  ProgressImageView.swift
//  Weibo
//
//  Created by bughh on 2020/5/27.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

// 带进度的图像视图
class ProgressImageView: UIImageView {
    // rect = bounds
    /*
     面试题：如果在 UIImageView 的 drawRect 中绘图，会怎样？答：不会执行 drawRect 函数
     */
//    override func draw(_ rect: CGRect) {
//           let path = UIBezierPath(ovalIn: rect)
//           UIColor.red.setFill()
//           path.fill()
//    }
    
    private lazy var progressView: ProgressView = ProgressView()
    // 外部传递的进度值 0-1
    var progess: CGFloat = 0 {
        didSet {
            progressView.progess = progess
            
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
//    // 一旦给构造函数提供了参数，系统不再提供默认的构造函数
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(progressView)
        progressView.backgroundColor = .clear
        progressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
}

// MARK: - 进度视图
private class ProgressView: UIView {
    // 内部传递的进度值 0-1
    var progess: CGFloat = 0 {
        didSet {
            // 重绘视图
            self.setNeedsDisplay()
            
        }
    }
    // rect == bounds
    override func draw(_ rect: CGRect) {
        let c = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let r = min(rect.width, rect.height) * 0.5
        let start = CGFloat(-Double.pi / 2)
        let end = start + progess * 2 * CGFloat(Double.pi)
        let path = UIBezierPath(arcCenter: c, radius: r, startAngle: start, endAngle: end, clockwise: true)
        
        // 添加到圆心的连线
        path.addLine(to: c)
        path.close()
        
        UIColor(white: 1.0, alpha: 0.3).setFill()
        path.fill()
    }
    
}
