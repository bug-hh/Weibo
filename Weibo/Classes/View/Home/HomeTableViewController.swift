//
//  HomeTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import SVProgressHUD

private let StatusCellNormalID = "StatusCellNormalID"

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StatusCellNormalID)
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

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellNormalID, for: indexPath)
        let statusViewModel = listViewModel.statusList[indexPath.row]
        let status = statusViewModel.status
        cell.textLabel?.text = status.user?.screen_name
        return cell
    }
}
