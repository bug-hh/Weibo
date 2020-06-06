//
//  HomeWebViewController.swift
//  Weibo
//
//  Created by 彭豪辉 on 2020/6/6.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import WebKit

class HomeWebViewController: UIViewController {

    private lazy var webView: WKWebView = WKWebView()
    
    private var url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
    }
    
    // loadView 用于设置页面的层次结构的
    override func loadView() {
        view = webView
        title = "网页"
    }
    
}
