//
//  HomeTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SVProgressHUD

let StatusCellNormalID = "StatusCellNormalID"
let StatusRetweetedCellID = "StatusRetweetedCellID"

class HomeTableViewController: VisitorTableViewController {

    // 照片查看转场动画代理
    private lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    private lazy var listViewModel: StatusListViewModel = StatusListViewModel()
    
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.color = .lightGray
        return indicator
    }()
    
    private var dataList: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedViewModel.userLogin {
            visitView?.setUpInfo(imageName: nil, text: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        prepareTableView()
        loadData()
        
        // 注册通知, 如果使用通知中心的 block 监听，其中的 self 一定要弱引用
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBStatusSelectedPhotoNotification),
                                               object: nil,  // 发送通知的对象，如果为 nil，则监听所有对象
                                               queue: nil)   // 如果为 nil，那么 queue 就用 主线程
        { [weak self] (notification) in
            print("接收通知 \(notification)")
            guard let indexPath = notification.userInfo?[NSNotification.Name(rawValue: WBStatusSelectedPhotoIndexPathKey)] else {
                return
            }
            
            guard let urls = notification.userInfo?[NSNotification.Name(rawValue: WBStatusSelectedPhotoURLsKey)] else {
                return
            }
            
            // 判断 cell 是否遵守了 PhotoBrowserPresentDelegate 展现动画协议
            guard let cell = notification.object as? PhotoBrowserPresentDelegate else {
                return
            }
            
            let vc = PhotoBrowserViewController(urls: urls as! [URL], indexPath: indexPath as! IndexPath)
            // 设定 modal 的转场（动画）类型是自定义类型
            vc.modalPresentationStyle = .custom
            // 设置动画代理
            vc.transitioningDelegate = self?.photoBrowserAnimator
            
            // 设置展现动画代理和相关参数
            self?.photoBrowserAnimator.setDelegateWithIndexPath(presentDelegate: cell, indexPath: indexPath as! IndexPath, dismissDelegate: vc)
            // modal 展现
            self?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareTableView() {
        // 注册可重用 cell
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: StatusRetweetedCellID)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusCellNormalID)
        
        // 取消分割线
        tableView.separatorStyle = .none
        
        // 自行计算行高 - 需要一个自上而下的自动布局的控件，指向一个向下的约束
        tableView.estimatedRowHeight = 400
        
        // 下拉刷新控件，默认没有，高度 60
        refreshControl = WeiboRefreshControl()
        // 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // 上拉刷新视图
        tableView.tableFooterView = pullUpView
    }
    
    @objc private func loadData() {
        refreshControl?.beginRefreshing()
        listViewModel.loadStatus(isPullup: pullUpView.isAnimating) { (isSuccessed) in
            // 关闭刷新控件
            self.refreshControl?.endRefreshing()
            // 关闭上拉刷新
            self.pullUpView.stopAnimating()
            
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            // 加载数据
            self.tableView.reloadData()
        }

        
    }

}

// MARK: - 数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = listViewModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellID, for: indexPath) as! StatusCell
        cell.viewModel = vm
        // 判断是否是最后一条微博
        if indexPath.row == listViewModel.statusList.count - 1 && !pullUpView.isAnimating {
            // 开始上拉刷新动画
            pullUpView.startAnimating()
            loadData()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.statusList[indexPath.row].rowHeight
    }
}
