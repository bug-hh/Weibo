//
//  NetTools.swift
//  Weibo
//
//  Created by bughh on 2020/5/1.
//  Copyright © 2020 bughh. All rights reserved.
//

import UIKit
import Alamofire


class NetToolsUsingAlamfire {
    let appKey = "3305836468"
    let appSecret = "e75ef60521e249f5dd2882d288c98907"
    let redirectUrl = "https://bug-hh.github.io/bughh.github.io/"
    
    // 网络请求回调，类似于 OC 的 typedef
    typealias HHRequestCallBack = (_ result: Any?, _ error: Error?) -> ()
    
    // 单例
    static let sharedTools = NetToolsUsingAlamfire()

}

// MARK: - 获取用户微博数据方法
extension NetToolsUsingAlamfire {
    
    /**
          加载微博数据
        * parameter since_id   若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        * parameter max_id   若指定此参数，则返回ID小于或等于max_id的微博，默认为0
        * parameter finish  回调函数
     */
    func loadStatus(since_id: Int, max_id: Int, finish: @escaping HHRequestCallBack) {
        // 创建参数字典
        var parameters = [String: Any]()
        
        
        // 判断是否下拉刷新
        if since_id > 0 {
            parameters["since_id"] = since_id
        } else if max_id > 0 {  // 判断是否为上拉
            // 减一，为了防止 等于 max_id 的微博重复
            parameters["max_id"] = max_id - 1
        }
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        self.tokenRequest(method: .get, url: url, parameters: &parameters, finish: finish)
        
    }
}

// MARK: - 第三方分享一条链接到微博
extension NetToolsUsingAlamfire {
    /**
            * see [https://open.weibo.com/wiki/2/statuses/share](https://open.weibo.com/wiki/2/statuses/share)
     */
    func share(status: String, image: UIImage?, finish: @escaping HHRequestCallBack) {
        // 创建参数字典
        var parameters = [String: Any]()
        
        parameters["status"] = status
        let url = "https://api.weibo.com/2/statuses/share.json"
        
        if let img = image {
            let d = img.pngData()
            upload(url: url, data: d!, name: "pic", parameters: &parameters, finish: finish)
        } else{
            self.tokenRequest(method: .post, url: url, parameters: &parameters, finish: finish)
        }
        
    }
    
}

// MARK: - 获取微博用户信息方法
extension NetToolsUsingAlamfire {
    func loadUserInfo(uid: String?, finish: @escaping HHRequestCallBack) {
        // 创建参数字典
        var parameters = [String: Any]()
        
        let url = "https://api.weibo.com/2/users/show.json"
        parameters["uid"] = uid
        self.tokenRequest(method: .get, url: url, parameters: &parameters, finish: finish)
    }
    
}

// MARK: - OAuth 相关方法
extension NetToolsUsingAlamfire {
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
        self.request(method: .post, url: url, parameters: parameters, finish: finish)
//        post(url, parameters: parameters, headers: nil, progress: nil, success: { (_, result) in
//            let json = result as? [String: Any]
//            print(json!)
//            let ua = UserAccount(dict: json!)
//            print(ua.access_token)
//        }, failure: nil)
    }
}


// MARK: - 封装 AFN 网络方法
extension NetToolsUsingAlamfire {
    
    func appendToken(parameters: inout [String: Any]) -> Bool {
        guard let token = UserAccountViewModel.sharedViewModel.accessToken else {
            return false
        }
        if parameters == nil {
            parameters = [String: Any]()
        }
        parameters["access_token"] = token
        return true
    }
    
    func tokenRequest(method: HTTPMethod, url: String, parameters: inout [String : Any], finish: @escaping HHRequestCallBack) {
        // 将 token 参数添加到 parameters 字典
        // 判断 token 是否有效
        if !appendToken(parameters: &parameters) {
            finish(nil, NSError(domain: "com.bughh.error", code: 1000, userInfo: ["message": "无效 token"]) as Error)
            return
        }
        // 发起网络请求
        self.request(method: method, url: url, parameters: parameters, finish: finish)
        
    }
    
    
//    新版的Swift闭包做参数默认是@noescaping，不再是@escaping。所以如果函数里异步执行该闭包，要添加@escaping。
    func request(method: HTTPMethod, url: String, parameters: [String: Any]?, finish: @escaping HHRequestCallBack) {
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            if response.result.isFailure {
                print("网络请求失败 \(response.result.error)")
            }
            finish(response.result.value, nil)
        }
    }
    
    func upload(url: String, data: Data, name: String, parameters: inout [String: Any], finish: @escaping HHRequestCallBack) {
        // 将 token 参数添加到 parameters 字典
        // 判断 token 是否有效
        if !appendToken(parameters: &parameters) {
            finish(nil, NSError(domain: "com.bughh.error", code: 1000, userInfo: ["message": "无效 token"]) as Error)
            return
        }
        
        /*
            data: 要上传文件的二进制数据
            name: 服务器定义的字段名称 - 后台接口文档会提示
            fileName: 保存在服务器的文件名，通常可以乱写，后端会做后续处理
                根据上传的文件，生成 缩略图，中等图，高清图
                保存在不同的路径，并自动生成文件名
                fileName 是 HTTP 协议定义的属性
            mimeType / contentType: 客户端告诉服务器，二进制数据的准确类型
                例如：image/jpg
                如果不想告诉服务器
                     application/octet-stream
         */
        
        let pt = parameters
        Alamofire.upload(
            multipartFormData: { (formData) in
                /*
                 append 方法中，带 mimeType 的是拼接上传文件的方法
                 append 方法中，不带 mineType 的是拼接普通二进制数据的方法
                 */
                formData.append(data, withName: name, mimeType: "application/octet-stream")
                // 遍历参数字典
                for (k, v) in pt {
                    let str = v as! String
                    let strData = str.data(using: .utf8)
                    
                    formData.append(strData!, withName: k)
                }
                
            },
            usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
            with: url as! URLRequestConvertible,
            encodingCompletion: {(encodingResult) in
                switch encodingResult {
                case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                    request.responseJSON { (response) in
                        if response.result.isFailure {
                            print("网络请求失败")
                        }
                        finish(response.result.value, nil)
                    }
                case .failure(_):
                    print("上传文件编码错误")
                }
            })
//        post(url, parameters: parameters, headers: nil, constructingBodyWith: { (formData) in
//            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "multipart/form-data")
//        }, progress: nil, success: { (_, result) in
//            finish(result, nil)
//        }) { (_, error) in
//            finish(nil, error)
//        }
    }
    
}
