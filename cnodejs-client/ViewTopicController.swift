//
//  ViewTopicController.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/2.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
//import Alamofire

class ViewTopicController: UIViewController,UIWebViewDelegate,UITableViewDataSource/*, HttpProtocol*/ {
    
    var topic:JSON?
//    var topicId:String?
//    var topicTitle:String?
//    var topicContent:String?
    
    @IBOutlet weak var webView: UIWebView!
 
    @IBOutlet weak var enshrine: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    //let httpReq = HttpDataSource()
    
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置返回按钮的图标
        var bItem = UIBarButtonItem(image: UIImage(named: "iconfont-back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backHeader")
        self.navigationItem.leftBarButtonItem = bItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        initWebView()
        initTableView()
        
        /*
        httpReq.delegate = self
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topic/"+self.topicId!)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化WebView
    func initWebView(){
        let topicId = self.topic?["id"].string
        var topicContent = self.topic?["content"].string
        let topicTitle = self.topic?["title"].string
        
        //设置WebView的内容
        let titleHtml = "<h2>\(topicTitle!)</h2>"
        topicContent = topicContent?.stringByReplacingOccurrencesOfString("//dn-cnode", withString: "https://dn-cnode", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        self.webView.loadHTMLString(titleHtml+topicContent!, baseURL: bundleUrl)
    }
    
    //初始化TableView
    func initTableView() -> Void {
        let screenBounds = UIScreen.mainScreen().bounds
        self.tableView = UITableView(frame: CGRect(x: 0, y: screenBounds.height, width: screenBounds.width, height: screenBounds.height), style: UITableViewStyle.Plain)
        self.tableView.dataSource = self
        
        self.scrollView.addSubview(self.tableView)
        
        let equalWidth = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        let equalHeight = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        equalWidth.active = true
        equalHeight.active = true
    }
    
    func backHeader(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
