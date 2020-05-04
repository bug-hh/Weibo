//
//  HomeTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

private let StatusCellNormalID = "StatusCellNormalID"

class HomeTableViewController: VisitorTableViewController {

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
        NetTools.sharedTools.loadStatus { (result, error) in
            if error != nil {
                print("出错了")
                return
            }
            
            let resultDict = result as? [String: Any?]
            guard let array = resultDict?["statuses"] as? [[String: Any?]] else {
                print("数据格式错误")
                return
            }
            
            var arrayList = [Status]()
            for dict in array {
                arrayList.append(Status(dict: dict))
            }
            self.dataList = arrayList
            print(arrayList)
            self.tableView.reloadData()
        }
    }

}


extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellNormalID, for: indexPath)
        cell.textLabel?.text = self.dataList![indexPath.row].text
        return cell
    }
}
