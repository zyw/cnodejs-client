//
//  ViewLeftMenuController.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/4.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
import RESideMenu

class ViewLeftMenuController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var filterDelegate:ViewLeftMenuDelegate?
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var menuTV: UITableView!
    
    let menus = [
                    ["icon":"iconfont-shouye","title":"全部","flag":"all"],
                    ["icon":"iconfont-zan","title":"精华","flag":"good"],
                    ["icon":"iconfont-fenxiang","title":"分享","flag":"share"],
                    ["icon":"iconfont-pinglun","title":"问答","flag":"ask"],
                    ["icon":"iconfont-tianmaohuiyuan","title":"招聘","flag":"job"]
                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage.image = UIImage(named: "left-bg")
        menuTV.dataSource = self
        menuTV.delegate = self
        //清除表格的背景
        menuTV.backgroundColor = UIColor.clearColor()
        //去掉行间的分割线
        menuTV.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let menuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! UITableViewCell
        
        let icon = menuCell.viewWithTag(1) as! UIImageView
        icon.image = UIImage(named: menus[indexPath.row]["icon"]!)
        let name = menuCell.viewWithTag(2) as! UILabel
        name.text = menus[indexPath.row]["title"]
        name.textColor = UIColor.whiteColor()
        /*
        //设置文本的颜色
        menuCell.textLabel?.textColor = UIColor.whiteColor()
        menuCell.textLabel?.text = menus[indexPath.row]["title"]
        menuCell.imageView?.image = UIImage(named: menus[indexPath.row]["icon"]!)
        menuCell.imageView?.tintColor = UIColor.whiteColor()
        */
        
        //清除单元格的背景
        menuCell.backgroundColor = UIColor.clearColor()
        return menuCell
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        filterDelegate?.didFilterTag(menus[indexPath.row]["title"]!,tag:menus[indexPath.row]["flag"]!)
        (self.view.window?.rootViewController as! RESideMenu).hideMenuViewController()
        return indexPath
    }
}
protocol ViewLeftMenuDelegate{
    func didFilterTag(title:String,tag:String)
}