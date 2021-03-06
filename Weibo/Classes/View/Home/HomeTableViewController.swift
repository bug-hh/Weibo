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
    /*
     tag 用来标识：
     0、登录用户所有微博
     1、@我的微博
     2、评论我的微博
     3、点赞我的微博
     */
    var tag = 0

    // 照片查看转场动画代理
    lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    lazy var listViewModel: StatusListViewModel = StatusListViewModel()
    
    lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.color = .lightGray
        return indicator
    }()
    
    // 懒加载下拉刷新提示控件
    lazy var pullDownTipLabel: UILabel = {
        let label = UILabel(text: "", fontSize: 18, textColor: .white)
        label.backgroundColor = .orange
        
        navigationController?.navigationBar.insertSubview(label, at: 0)
        return label
    }()
    
    var dataList: [Status]?
    
    convenience init(tag: Int = 0) {
        self.init()
        self.tag = tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedViewModel.userLogin {
            visitView?.setUpInfo(imageName: nil, text: "关注一些人，回这里看看有什么惊喜")
            return
        }
        prepareTableView()
        loadData()
        print("loadData end")
        // 注册通知, 如果使用通知中心的 block 监听，其中的 self 一定要弱引用
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBStatusSelectedPhotoNotification),
                                               object: nil,  // 发送通知的对象，如果为 nil，则监听所有对象
                                               queue: nil)   // 如果为 nil，那么 queue 就用 主线程
        { [weak self] (notification) in
//            print("接收通知 \(notification)")
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
    
    func prepareTableView() {
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
    
    @objc func loadData() {
        print("loadData begin")
        refreshControl?.beginRefreshing()
        listViewModel.loadStatus(tag: self.tag, isPullup: pullUpView.isAnimating) { (isSuccessed) in
            // 关闭刷新控件
            self.refreshControl?.endRefreshing()
            // 关闭上拉刷新
            self.pullUpView.stopAnimating()
            
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                return
            }
            
            // 显示下拉刷新提示
            self.showPullDownTip()
            
            // 加载数据
            self.tableView.reloadData()
        }
    }
    
    // 显示下拉刷新提示
    func showPullDownTip() {
        // 如果不是下拉刷新，则直接返回
        guard let count = listViewModel.pullDownCount else {
            return
        }
        print("下拉刷新 \(count)")
        let message = count > 0 ? "没有新微博" : "刷新到 \(count) 条微博"
        pullDownTipLabel.text = message
       
        
        let height: CGFloat = 44
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        pullDownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * height)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.pullDownTipLabel.frame = rect.offsetBy(dx: 0, dy: height)
        }) { (_) in
            UIView.animate(withDuration: 1.0) {
                self.pullDownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * height)
            }
        }
    }

}

// MARK: - 数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tag == ALL_STATUS {
            return listViewModel.statusList.count
        }
        
        if self.tag == MENTIONED_STATUS {
            return listViewModel.mentionedStatusList.count
        }
        
        if self.tag == COMMENT_STATUS {
            return listViewModel.commentStatusList.count
        }
        
        if self.tag == UPVOTE_STATUS {
            return listViewModel.upvoteStatusList.count
        }
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempList:[StatusWeiboViewModel]? = nil
        var tempVM: StatusWeiboViewModel? = nil
        if self.tag == MENTIONED_STATUS {
            tempVM = listViewModel.mentionedStatusList[indexPath.row]
            tempList = listViewModel.mentionedStatusList
        } else if self.tag == COMMENT_STATUS {
            tempVM = listViewModel.commentStatusList[indexPath.row]
            tempList = listViewModel.commentStatusList
        } else if self.tag == UPVOTE_STATUS {
            tempVM = listViewModel.upvoteStatusList[indexPath.row]
            tempList = listViewModel.upvoteStatusList
        } else if self.tag == ALL_STATUS {
            tempVM = listViewModel.statusList[indexPath.row]
            tempList = listViewModel.statusList
        }
        
        guard let vm = tempVM, let TL = tempList else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellID, for: indexPath) as! StatusCell
        cell.viewModel = vm
        if self.tag == MENTIONED_STATUS {
            print(vm.status)
        }
        // 判断是否是最后一条微博 同时这个 tag 是首页微博，不是 message
        if indexPath.row == TL.count - 1 && !pullUpView.isAnimating && self.tag == ALL_STATUS {
            // 开始上拉刷新动画
            pullUpView.startAnimating()
            loadData()
        }
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tag == ALL_STATUS {
            return listViewModel.statusList[indexPath.row].rowHeight
        }
        
        if self.tag == MENTIONED_STATUS {
            return listViewModel.mentionedStatusList[indexPath.row].rowHeight
        }
        
        if self.tag == COMMENT_STATUS {
            return listViewModel.commentStatusList[indexPath.row].rowHeight
        }
        
        if self.tag == UPVOTE_STATUS {
            return listViewModel.upvoteStatusList[indexPath.row].rowHeight
        }
        
        return 0
    }
}

// MARK: - StatusCellDelegate
extension HomeTableViewController: StatusCellDelegate {
    func statusCellDidClickUrl(url: URL) {
        // 建立 webview 控制器
        let vc = HomeWebViewController(url: url)
        // 跳转 webview 后，隐藏 tab bar
        vc.hidesBottomBarWhenPushed = true
        // 如果当前控制器与要跳转的控制器存在某种联系时，用 push
        navigationController?.pushViewController(vc, animated: true)
    }
}
