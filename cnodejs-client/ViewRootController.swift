//
//  ViewRootController.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/4.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
import RESideMenu

class ViewRootController: RESideMenu,RESideMenuDelegate {
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent;
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
        
        let contentController = self.storyboard?.instantiateViewControllerWithIdentifier("viewContentController") as! UINavigationController
        
        self.contentViewController = contentController
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftMenuController") as! ViewLeftMenuController
        //self.rightMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftMenuController") as! ViewLeftMenuController
        
        //(self.storyboard?.instantiateViewControllerWithIdentifier("homeController") as! ViewController).menu = self
        
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
