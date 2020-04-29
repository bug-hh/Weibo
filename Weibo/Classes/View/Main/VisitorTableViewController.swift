//
//  VisitorTableViewController.swift
//  Weibo
//
//  Created by bughh on 2020/4/28.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController, VisitorDelegate {

    /*
            提问：应用程序里有几个 visitview？有四个，每个控制器各自拥有自己的 visitview
            提问：访客视图如果用懒加载会怎样？如果使用懒加载，访客视图始终会被创建出来
     */
    var userLogin = false
    var visitView: VisitorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        userLogin ? super.loadView() : setupVistorView()
    }
    
    private func setupVistorView() {
        visitView = VisitorView()
        visitView?.delegate = self
        view = visitView
    }
  

    
    // MARK - VisitorDelegate
    func register() {
        print("注册")
    }
    
    func login() {
        print("登录")
    }
    
    

}
