//
//  OAuthViewController.swift
//  Weibo
//
//  Created by bughh on 2020/5/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import WebKit

class OAuthViewController: UIViewController, WKNavigationDelegate {

    private var webView = WKWebView()
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
        let js = "document.getElementById('userId').value = '13167302688';" + "document.getElementById('passwd').value = 'phh!!0905'"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: NetTools.sharedTools.oauthURL))
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
            decisionHandler(.cancel)
            return
        }
        
        // 获取授权码
        let startIndex = query.index(query.startIndex, offsetBy: 5)
        let code = query[startIndex..<query.endIndex]
        print(webView.url?.host ?? "nil")
        print(webView.url?.query ?? "nil")
        print(code)
        
        // 根据授权码，获取 accessToken
        NetTools.sharedTools.accessToken(code: String(code)) { (result, error) in
            if let err = error {
                print(err)
                return
            }
            
            // result 是 Any? 类型，所以一定要使用 as? 或者 as!
            let userAccount = UserAccount(dict: result as! [String: Any])
            // 在闭包里，调用实例方法是，一定要加上 self
            self.loadUserInfo(userAccount: userAccount)
        }
        decisionHandler(.allow)
    }
    
    private func loadUserInfo(userAccount: UserAccount) {
        NetTools.sharedTools.loadUserInfo(access_token: userAccount.access_token!, uid: userAccount.uid!) { (result, error) in
            if error != nil {
                print("加载用户信息错误")
                return
            }
            
            // 如果使用 if/let 或 guard/let 通透使用 as?   [String: Any] 可以换成 NSDictionary
            guard let dict = result as? [String: Any] else {
                return
            }
            
            userAccount.screenName = dict["screen_name"] as? String
            userAccount.avatarLarge = dict["avatar_large"] as? String
            userAccount.saveUserAccount()
            print(userAccount)
        }
        
    }
    
}
