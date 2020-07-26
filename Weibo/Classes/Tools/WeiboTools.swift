//
//  WeiboTools.swift
//  Weibo
//
//  Created by bughh on 2020/7/25.
//  Copyright © 2020 bughh. All rights reserved.
//

import Pods_Weibo

class WeiboTools {
    // 单例
    static let sharedTools: WeiboTools = {
        let tools = WeiboTools()
        return tools
    }()
    
    func ssoLogin() {
        let request = WBAuthorizeRequest()
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
        WeiboSDK.send(request)
    }
}
