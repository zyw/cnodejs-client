//
//  TopicsInfo.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/22.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import Foundation

struct TopicsInfo {
    static var topicLists:[JSON] = []
    static var tag:String = "all"
    static var page:Int = 1
    static var isMore = false
    
    static var selectedRowIndex:Int?
}
