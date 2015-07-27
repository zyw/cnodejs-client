//
//  CircularUIImageView.swift
//  cnodejs-client
//
//  Created by zyw on 15/7/27.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit

class CircularUIImageView: UIImageView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }

}
