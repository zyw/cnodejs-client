//
//  KitTool.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/1.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit

class KitTool {
    //设置当前时区的日期和时间
    class func getNowDateFromatAnDate(anyDate:NSDate) ->NSDate {
        //获得本地日期的时区
        let timeZone = NSTimeZone.localTimeZone()
        //获得时间的偏移量
        let interval = timeZone.secondsFromGMTForDate(anyDate)
        
        return anyDate.dateByAddingTimeInterval(NSTimeInterval(interval))
    }
    
    //获得发帖子的时间
    class func topicTime(time:Double) -> String{
        if time >= 60 {
            let m = time/60
            if m >= 60 {
                let h = m/60
                if h >= 24 {
                    let d = h/24
                    return "\(Int(d))天前"
                }else{
                    return "\(Int(h))小时前"
                }
            }else{
                return "\(Int(m))分钟前"
            }
        }else{
            return "\(Int(time))秒前"
        }

    }
}
//String类扩展
extension String {
    func stringByReplacingRegex(regex:NSRegularExpression,repeatStr:String) -> String {
        
        let range = NSMakeRange(0, count(self))
        let trimmedString = regex.stringByReplacingMatchesInString(self, options: .ReportProgress, range:range, withTemplate:"$1")
            
        return trimmedString
    }
    //清除字符串中的HTM或者XML中的标签
    func stringByReplaceingHtml(repeatStr:String) -> String {
        let htmlRegex = "<[^>]+>"
        if let regex = NSRegularExpression(pattern: htmlRegex, options: .CaseInsensitive, error: nil) {
            return self.stringByReplacingRegex(regex, repeatStr: repeatStr)
        } else {
            return self
        }
    }
}
