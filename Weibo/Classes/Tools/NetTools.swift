//
//  NetTools.swift
//  Weibo
//
//  Created by bughh on 2020/5/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import AFNetworking

// HTTP 请求方法枚举
enum HHRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class NetTools: AFHTTPSessionManager {
    let appKey = "3305836468"
    let appSecret = "e75ef60521e249f5dd2882d288c98907"
    let redirectUrl = "https://bug-hh.github.io/bughh.github.io/"
    
    // 网络请求回调，类似于 OC 的 typedef
    typealias HHRequestCallBack = (_ result: Any?, _ error: Error?) -> ()
    
    // 单例
    static let sharedTools: NetTools = {
        let tools = NetTools(baseURL: nil)
        // 设置反序列化数据格式 - 系统会自动将 OC 框架中的 NSSet 转换成 Set, 不设置好像也能用
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()

    private var tokenDict:[String: Any]? {
        if let token = UserAccountViewModel.sharedViewModel.accessToken {
            return ["access_token": token]
        }
        return nil
    }

}

// MARK: - 获取微博用户信息方法
extension NetTools {
    func loadUserInfo(uid: String?, finish: @escaping HHRequestCallBack) {
        // 获取 token 字典
        guard var parameters = tokenDict else {
            finish(nil, NSError(domain: "com.bughh.error", code: 1000, userInfo: ["message": "无效 token"]) as Error)
            return
        }
        let url = "https://api.weibo.com/2/users/show.json"
        parameters["uid"] = uid
        request(method: .GET, url: url, parameters: parameters as [String : Any], finish: finish)
    }
    
}

// MARK: - OAuth 相关方法
extension NetTools {
    /// OAuth 授权 URL
    /// see: [https://open.weibo.com/wiki/Oauth2/authorize](https://open.weibo.com/wiki/Oauth2/authorize)
    var oauthURL: URL {
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrl)"
        return URL(string: url)!
    }
    
    func accessToken(code: String, finish: @escaping HHRequestCallBack) {
        let url = "https://api.weibo.com/oauth2/access_token"
        let parameters = [
            "client_id": "3305836468",
            "client_secret": "e75ef60521e249f5dd2882d288c98907",
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": "https://bug-hh.github.io/bughh.github.io/"
        ]
        request(method: .POST, url: url, parameters: parameters, finish: finish)
        
//        post(url, parameters: parameters, headers: nil, progress: nil, success: { (_, result) in
//            let json = result as? [String: Any]
//            print(json!)
//            let ua = UserAccount(dict: json!)
//            print(ua.access_token)
//        }, failure: nil)
    }
    
    
}
// MARK: - 封装 AFN 网络方法
extension NetTools {
//    新版的Swift闭包做参数默认是@noescaping，不再是@escaping。所以如果函数里异步执行该闭包，要添加@escaping。
    
    func request(method: HHRequestMethod, url: String, parameters: [String: Any]?, finish: @escaping HHRequestCallBack) {
        
        // 第一种写法，推荐写法
        let success = { (task: URLSessionDataTask, result: Any?) in
            finish(result, nil)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) in
            finish(nil, error)
        }
        
        if method == .GET {
            get(url, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        } else if method == .POST {
            post(url, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        }
        
        
        // 第二种写法
//        if method == .GET {
//            get(url, parameters: parameters, headers: nil, progress: nil, success: { (_, result) in
//                finish(result, nil)
//            }) { (_, error) in
//                //  在开发网络应用的时候，错误不要提示给用户，但是错误一定要输出
//                print(error)
//                finish(nil, error as NSError?)
//            }
//        } else if method == .POST {
//            post(url, parameters: parameters, headers: nil, progress: nil, success: { (_, result) in
//                finish(result, nil)
//            }) { (_, error) in
//                //  在开发网络应用的时候，错误不要提示给用户，但是错误一定要输出
//                print(error)
//                finish(nil, error as NSError?)
//            }
//        }
        
        
    }
    
}
