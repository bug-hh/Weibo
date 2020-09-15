//
//  Common.swift
//  Weibo
//
//  Created by bughh on 2020/5/3.
//  Copyright © 2020 bughh. All rights reserved.
//

import Foundation

let appKey = "1544083852"
let appSecret = "4b58f11df38687b482d0813696ba7e86"
let redirectUrl = "https://api.weibo.com/oauth2/default.html"

// 切换根视图控制器通知
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"

// 选中照片通知
let WBStatusSelectedPhotoNotification = "WBStatusSelectedPhotoNotification"
// 选中照片的 indexpath
let WBStatusSelectedPhotoIndexPathKey = "WBStatusSelectedPhotoIndexPathKey"
// 选中照片的 URL
let WBStatusSelectedPhotoURLsKey = "WBStatusSelectedPhotoURLsKey"

// tag, 区分是登录用户所有微博、@我的、评论我的、点赞我的
let ALL_STATUS = 0
let MENTIONED_STATUS = 1
let COMMENT_STATUS = 2
let UPVOTE_STATUS = 3


