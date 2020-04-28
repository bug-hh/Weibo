//
//  VisitorTableViewController.swift
//  Weibo
//
//  Created by bughh on 2020/4/28.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {

    var userLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func loadView() {
        userLogin ? super.loadView() : setupVistorView()
    }
    
    private func setupVistorView() {
        view = VisitorView()
    }
  


}
