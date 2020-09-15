//
//  MessageTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

let MessageCellID = "MessageCellID"

class MessageTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedViewModel.userLogin {
            visitView?.setUpInfo(imageName: "visitordiscover_image_message", text: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
        prepareTableView()
        tableView.reloadData()
    }
    
    func prepareTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: MessageCellID)
    }
}

// MARK: - Table view data source
extension MessageTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCellID, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "@我的"
            cell.imageView?.image = UIImage(named: "at-sign")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "评论"
            cell.imageView?.image = UIImage(named: "comment")
        } else {
            cell.textLabel?.text = "点赞"
            cell.imageView?.image = UIImage(named: "upvote")
        }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("获取指定 cell 失败")
            return
        }
        
        let vc = HomeTableViewController(tag: indexPath.row + 1)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
