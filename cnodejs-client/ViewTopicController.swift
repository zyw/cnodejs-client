//
//  ViewTopicController.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/2.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
//import Alamofire

class ViewTopicController: UIViewController,UIWebViewDelegate,UITableViewDataSource, HttpProtocol {
    
    var topic:JSON?
    
    var replies:[JSON] = []
 
    @IBOutlet weak var enshrine: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let httpReq = HttpDataSource()
    
    var webView: UIWebView!
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置返回按钮的图标
        var bItem = UIBarButtonItem(image: UIImage(named: "iconfont-back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backHeader")
        self.navigationItem.leftBarButtonItem = bItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let svBounds = scrollView.bounds
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: svBounds.height*2)
        
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        
        initTableView()
        initWebView()
        
        httpReq.delegate = self
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topic/"+(self.topic?["id"].string)!+"?mdrender=false")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didRecieveResults(result:AnyObject) {
        let json = JSON(result)
        self.replies = json["data"]["replies"].arrayValue
        
        self.tableView.reloadData()
    }
    
    func didRecieveFailed(error:NSError?) {
        
    }
    
    //初始化WebView
    func initWebView(){
        let svBounds = scrollView.bounds
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: svBounds.width, height: svBounds.height))
        
        self.scrollView.addSubview(self.webView)
        
        /*
        let equalTop = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let equalLeft = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let equalRight = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        equalTop.active = true
        equalLeft.active = true
        equalRight.active = true
        */
        
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
        let svBounds = scrollView.bounds
        self.tableView = UITableView(frame: CGRect(x: 0, y: svBounds.height, width: svBounds.width, height: svBounds.height), style: UITableViewStyle.Plain)
        self.tableView.dataSource = self
        
        self.scrollView.addSubview(self.tableView)
        
        /*
        let equalTop = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.webView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let equalLeft = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let equalRight = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        equalTop.active = true
        equalLeft.active = true
        equalRight.active = true
        */
    }
    
    func backHeader(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "comment-cell")
        let replie = replies[indexPath.row]
        println(replie["content"].string)
        cell.textLabel?.text = replie["content"].string
        return cell
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
