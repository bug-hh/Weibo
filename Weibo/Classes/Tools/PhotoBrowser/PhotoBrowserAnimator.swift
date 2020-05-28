//
//  PhotoBrowserAnimator.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/27.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

// MARK: - 展现动画协议
protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    //  指定 indexPath 对应的 imageView，用来做动画效果
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView
    // 动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect
    // 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect
}

// MARK: - 解除动画协议
protocol PhotoBrowserDismissDelegate: NSObjectProtocol {
    func imageViewForDismiss() -> UIImageView
    func indexPathForDismiss() -> IndexPath
}

// 提供动画转场的代理
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    // 展示动画代理
    weak var presentDelegate: PhotoBrowserPresentDelegate?
    
    // 解除动画代理
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    
    // 动画图像的索引
    var presentIndexPath: IndexPath?
    
    // 是否 modal 展现的标记
    private var isPresented = false
    
    // 设置代理和相关参数
    func setDelegateWithIndexPath(presentDelegate: PhotoBrowserPresentDelegate,
                                  indexPath: IndexPath,
                                  dismissDelegate: PhotoBrowserDismissDelegate) {
        self.presentDelegate = presentDelegate
        self.presentIndexPath = indexPath
        self.dismissDelegate = dismissDelegate
    }
    
    // 返回提供 modal 展现的 动画对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    // 返回 dismiss 的动画对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }

}

// MARK: - UIViewControllerAnimatedTransitioning
// 实现具体的动画方法
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    // 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    // 实现具体的动画效果, 一旦实现了此方法，所有动画代码都交由程序员负责
    // parameter: transitionContext: 转场动画上下文，提供动画所需要的素材
    /*
        容器视图：containerView, 会将 Modal 要展现的视图包装在容器视图当中，
        存放的视图要显示，必须自己指定大小，不会通过自动布局填满屏幕
        viewController   fromVC/toVC
        view     fromView/toView
        completeTransition   无论转场动画是否被取消，都必须调用，否则，系统不做其他事件处理
        
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 自动布局系统不会对根视图做任何约束
//        let v = UIView(frame: UIScreen.main.bounds)
//        v.backgroundColor = .red
//        transitionContext.containerView.addSubview(v)
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        print(fromVC)
        print(toVC)
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        print(fromView)
        print(toView)
        
        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 判断展示代理是否存在
        guard let pd = presentDelegate, let indexPath = presentIndexPath else {
            return
        }
        
        // 获取 modal 要展现的控制器的根视图
        let toView = transitionContext.view(forKey: .to)
        // 将要展示的视图添加到容器视图中
        transitionContext.containerView.addSubview(toView!)
        
        // 获取缩略图
        let iv = pd.imageViewForPresent(indexPath: indexPath)
        // 设置缩略图相对于整个屏幕的位置
        iv.frame = pd.photoBrowserPresentFromRect(indexPath: indexPath)
        
        toView!.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView!.alpha = 1
        }) { (_) in
            // 将图像视图移除
            iv.removeFromSuperview()
            // 告诉系统转场动画已完成
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let pd = presentDelegate, let dd = dismissDelegate else {
            return
        }
        
        // 获取要 dismiss 的控制器的根视图
        let fromView = transitionContext.view(forKey: .from)
        fromView?.removeFromSuperview()
        
        // 获取图像视图
        let iv = dd.imageViewForDismiss()
        // 添加到容器视图
        transitionContext.containerView.addSubview(iv)
        
        // 获取 dismiss 的 indexPath
        let indexPath = dd.indexPathForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // 让 iv 运动到目标位置
            iv.frame = pd.photoBrowserPresentFromRect(indexPath: indexPath)
            
        }) { (_) in
            // 将 iv 从父视图中移除
            iv.removeFromSuperview()
            // 告诉系统转场动画已完成
            transitionContext.completeTransition(true)
        }
    }
    
}
