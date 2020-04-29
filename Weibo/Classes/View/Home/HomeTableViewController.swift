//
//  HomeTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class HomeTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitView?.setUpInfo(imageName: nil, text: "关注一些人，回这里看看有什么惊喜")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
