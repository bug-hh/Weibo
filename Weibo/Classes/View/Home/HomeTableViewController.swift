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

    private lazy var listViewModel: StatusListViewModel = StatusListViewModel()
    
    private var dataList: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedViewModel.userLogin {
            visitView?.setUpInfo(imageName: nil, text: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        prepareTableView()
        loadData()
    }
    
    private func prepareTableView() {
        // 注册可重用 cell
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: StatusRetweetedCellID)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusCellNormalID)
        
        // 取消分割线
        tableView.separatorStyle = .none
        
        // 自行计算行高 - 需要一个自上而下的自动布局的控件，指向一个向下的约束
        tableView.estimatedRowHeight = 400
    }
    
    private func loadData() {
        listViewModel.loadStatus { (isSuccessed) in
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.statusList[indexPath.row].rowHeight
    }
}
