//
//  PhotoBrowserAnimator.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/5/27.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

// 提供动画转场的代理
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    // 是否 modal 展现的标记
    private var isPresented = false
    
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
        return 2
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
        // 获取 modal 要展现的控制器的根视图
        let toView = transitionContext.view(forKey: .to)
        // 将要展示的视图添加到容器视图中
        transitionContext.containerView.addSubview(toView!)
        
        toView!.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView!.alpha = 1
        }) { (_) in
            // 告诉系统转场动画已完成
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 获取要 dismiss 的控制器的根视图
        let fromView = transitionContext.view(forKey: .from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView!.alpha = 0
        }) { (_) in
            // 将 fromView 从父视图中移除
            fromView?.removeFromSuperview()
            // 告诉系统转场动画已完成
            transitionContext.completeTransition(true)
        }
    }
    
}
