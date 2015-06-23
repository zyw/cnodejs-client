//
//  RoundUIImage.swift
//  demo
//
//  Created by zyw on 15/6/14.
//  Copyright (c) 2015年 测试. All rights reserved.
//

import UIKit

class RoundUIImageView: UIImageView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
}
