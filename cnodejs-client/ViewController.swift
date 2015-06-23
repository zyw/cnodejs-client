//
//  ViewController.swift
//  cnodejs-client
//
//  Created by zyw on 15/5/30.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import MONActivityIndicatorView
import MJRefresh
import RESideMenu

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MONActivityIndicatorViewDelegate, HttpProtocol,ViewLeftMenuDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let httpReq = HttpDataSource()
    
    var topic:JSON?
//    var topicId:String?
//    var topicTitle:String?
//    var topicContent:String?
    
//    var topicLists:[JSON] = []
//    var tag:String = "all"
//    var page:Int = 1
//    var isMore = false
    
    var indicatorView:MONActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置navigationBar样式
        //self.navigationController?.navigationBar.translucent = true
        //self.navigationController?.navigationBar.alpha = 0.3
        
        httpReq.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        
        //在iOS8中设置TableViewCell的高度自适应
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //一定要设置一个预设值，否则自适应不管用
        self.tableView.estimatedRowHeight = 65.0
        
        self.tableView.hidden = true
        
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topics?tab=\(TopicsInfo.tag)&page=\(TopicsInfo.page)")
        TopicsInfo.page++
        setLoadingView()
        setRefresh()
    }
    
    func setRefresh(){
        self.tableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.httpReq.onHttpRequest("https://cnodejs.org/api/v1/topics?tab=\(TopicsInfo.tag)")
            TopicsInfo.requestType = 1
        }
        
        //隐藏更新时间
        self.tableView.header.updatedTimeHidden = true
        
        self.tableView.addLegendFooterWithRefreshingBlock { () -> Void in
            self.httpReq.onHttpRequest("https://cnodejs.org/api/v1/topics?tab=\(TopicsInfo.tag)&page=\(TopicsInfo.page)")
            TopicsInfo.page++
            TopicsInfo.requestType = 2
        }
    }
    
    func setLoadingView(){
        self.indicatorView = MONActivityIndicatorView()
        self.view.addSubview(self.indicatorView)
        let centerY = NSLayoutConstraint(item: self.indicatorView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        let centerX = NSLayoutConstraint(item: self.indicatorView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.indicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerX.active = true
        centerY.active = true
        
        self.indicatorView.delegate = self;
        self.indicatorView.numberOfCircles = 6;
        self.indicatorView.radius = 8;
        self.indicatorView.internalSpacing = 3;
        self.indicatorView.duration = 0.5;
        self.indicatorView.delay = 0.2
        self.indicatorView.center = self.view.center;
        self.indicatorView.startAnimating()
    }
    
    //添加点击重试按钮
    func addRetryButton(){
        //使用代码创建一个按钮，感觉这么别扭
        let retryBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        retryBtn.setTitle("点击重试", forState: UIControlState.Normal)
        
        self.view.addSubview(retryBtn)
        
        let centerY = NSLayoutConstraint(item: retryBtn, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        let centerX = NSLayoutConstraint(item: retryBtn, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        retryBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerX.active = true
        centerY.active = true
        retryBtn.addTarget(self, action: "retryHeader:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func retryHeader(sender:UIButton){
        sender.removeFromSuperview()
        //self.view.remove
        setLoadingView()
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topics?tab=\(TopicsInfo.tag)&page=\(TopicsInfo.page)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showLeftMenu(sender: AnyObject) {
        let sideMenu = self.view.window?.rootViewController as! RESideMenu
        let leftMenu = sideMenu.leftMenuViewController as! ViewLeftMenuController
        if leftMenu.filterDelegate == nil{
            leftMenu.filterDelegate = self
        }
        sideMenu.presentLeftMenuViewController()
    }
    
    func didRecieveResults(result:AnyObject){
        let json = JSON(result)
        if TopicsInfo.requestType == 2 {
            TopicsInfo.topicLists += json["data"].arrayValue
            TopicsInfo.requestType = 0
        }else{
            TopicsInfo.topicLists = json["data"].arrayValue
        }
        
        self.tableView.hidden = false
        removeIndicatorView()
        endRefreshing()
        
        self.tableView.reloadData()
    }
    
    func didRecieveFailed(error:NSError?){
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "网络不给力")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0)
        if TopicsInfo.requestType == 1 || TopicsInfo.requestType == 2 {
            TopicsInfo.requestType = 0
        } else {
            removeIndicatorView()
            addRetryButton()
        }
        endRefreshing()
    }
    
    private func endRefreshing(){
        self.tableView.header.endRefreshing()
        self.tableView.footer.endRefreshing()
    }
    
    private func removeIndicatorView(){
        self.indicatorView.stopAnimating()
        self.indicatorView.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TopicsInfo.topicLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var topiccell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("topiccell") as! UITableViewCell
        
        let topic = TopicsInfo.topicLists[indexPath.row]
        let imgView = topiccell.viewWithTag(1) as! UIImageView
        let title = topiccell.viewWithTag(2) as! UILabel
        let image = topiccell.viewWithTag(3) as! UIImageView
        let dateTitle = topiccell.viewWithTag(4) as! UILabel
        let visit_count = topiccell.viewWithTag(6) as! UILabel
        let reply_count = topiccell.viewWithTag(5) as! UILabel
        
        title.text = topic["title"].string
        
        let visit = topic["visit_count"].number
        let reply = topic["reply_count"].number
        visit_count.text = "\(visit!)"
        reply_count.text = "\(reply!)"
        
        let top = topic["top"].bool!
        let good = topic["good"].bool!
        let cat = topic["tab"].string
        if top == true {
            image.image = UIImage(named: "icon-zd")
        }else{
            if good == true {
                image.image = UIImage(named: "icon-jh")
            }else{
                if cat != nil{
                    switch cat! {
                    case "share":
                        image.image = UIImage(named: "icon-fx")
                        break
                    case "ask":
                        image.image = UIImage(named: "icon-wd")
                        break
                    case "job":
                        image.image = UIImage(named: "icon-zp")
                        break
                    default:
                        image.image = nil
                    }
                }else{
                    image.image = nil
                }
            }
        }
        let dateString = topic["last_reply_at"].string
        
        //获得当前日期和时间
        let nowTime = KitTool.getNowDateFromatAnDate(NSDate())
        
        //通过日期时间字符串活动日期时间
        let dateFormatter = NSDateFormatter()
        //设置解析字符串的格式
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        //设置格式化日期的当前时区
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        //解析字符串获得日期对象 dateFormatter.dateFromString(dateString!)
        let replyTime = KitTool.getNowDateFromatAnDate(dateFormatter.dateFromString(dateString!)!)
        
        let time = nowTime.timeIntervalSinceDate(replyTime)
        dateTitle.text = KitTool.topicTime(time)
        
        var imgUrl = "https://cnodejs.org"+topic["author"]["avatar_url"].string!
        
        Alamofire.request(Alamofire.Method.GET, imgUrl).response{(_,_,result,error) in
            let img = UIImage(data: result as! NSData)
            imgView.image = img
        }
        
        return topiccell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        TopicsInfo.selectedRowIndex = indexPath.row
        self.topic = TopicsInfo.topicLists[indexPath.row]
        
        return indexPath
    }
    
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "cellSegue"{
            let tvc = segue.destinationViewController as! ViewTopicController
            tvc.topic = self.topic
        }
    }
    
    func activityIndicatorView(activityIndicatorView: MONActivityIndicatorView!, circleBackgroundColorAtIndex index: UInt) -> UIColor! {
        let red:CGFloat  = CGFloat(arc4random()%256)/255.0;
        let green:CGFloat = CGFloat(arc4random()%256)/255.0;
        let blue:CGFloat  = CGFloat(arc4random()%256)/255.0;
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
        
    }
    
    func didFilterTag(title:String,tag:String){
        self.navigationItem.title = title
        TopicsInfo.tag = tag
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topics?tab=\(TopicsInfo.tag)")
    }
}