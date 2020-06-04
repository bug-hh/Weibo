//
//  OAuthViewController.swift
//  Weibo
//
//  Created by bughh on 2020/5/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class OAuthViewController: UIViewController, WKNavigationDelegate {

    private var webView = WKWebView()
    
    @objc func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
        let js = "document.getElementById('userId').value = '13167302688';" + "document.getElementById('passwd').value = 'phh!!0905'"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: NetToolsUsingAlamfire.sharedTools.oauthURL))
    }
    
    override func loadView() {
        view = webView
        // 设置导航栏
        navigationItem.title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFill))
    }

}

// MARK - WKNavigationDelegate 代理方法
extension OAuthViewController {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 先判断 host 是否为给定的回调地址
        guard let host = webView.url?.host, host == "bug-hh.github.io" else {
            decisionHandler(.allow)
            return
        }
        
        // 再判断 query 里面有没有 code 参数，因为用户可能点击「取消授权」
        guard let query = webView.url?.query, query.hasPrefix("code=") else {
            print("用户取消了授权")
            close()
            decisionHandler(.cancel)
            return
        }
        
        // 获取授权码
        let startIndex = query.index(query.startIndex, offsetBy: 5)
        let code = query[startIndex..<query.endIndex]

        
        // 根据授权码，获取 accessToken, 这是一个尾随闭包
        UserAccountViewModel.sharedViewModel.loadAccessToken(code: String(code)) { (isSuccessed: Bool) in
            if !isSuccessed {
                print("获取 accessToken 失败")
                SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
                    self.close()
                })
                return
            }
//            Instance member 'asyncAfter' cannot be used on type 'DispatchQueue'; did you mean to use a value of this type instead?
            // 这个dismiss 方法不会立刻销毁控制器，所以需要在 completion 回调中，发送通知
            self.dismiss(animated: false) {
                // 关闭指示器
                SVProgressHUD.dismiss()
                // 登录完成以后，同时在销毁 OAuthViewController 以后，才发送通知，将控制器换成 newfeature viewcontroller
                // 通知中心是同步的，一旦发送通知，会先执行监听方法，结束后，才继续往后执行
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification),
                object: "welcome")
            }
            
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
}
