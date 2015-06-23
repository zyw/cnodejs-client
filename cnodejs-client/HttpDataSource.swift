//
//  HttpDataSource.swift
//  cnodejs-client
//
//  Created by zyw on 15/5/31.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
import Alamofire

class HttpDataSource{
    var delegate:HttpProtocol?
    func onHttpRequest(url:String){
        Alamofire.request(Alamofire.Method.GET,url).responseJSON{(_,_,result,error) in
            if let res: AnyObject = result{
                self.delegate?.didRecieveResults(res)
            }else{
                self.delegate?.didRecieveFailed(error)
            }
        }
    }
}


protocol HttpProtocol{
    func didRecieveResults(result:AnyObject)
    func didRecieveFailed(error:NSError?)
}