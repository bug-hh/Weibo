//
//  ProfileTableViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/4/26.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit

class ProfileTableViewController: VisitorTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitView?.setUpInfo(imageName: "visitordiscover_image_profile", text: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }

}
