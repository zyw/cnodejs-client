//
//  ViewTopicController.swift
//  cnodejs-client
//
//  Created by zyw on 15/6/2.
//  Copyright (c) 2015年 Nodejs中国客户端. All rights reserved.
//

import UIKit
//import Alamofire

class ViewTopicController: UIViewController,UIWebViewDelegate/*, HttpProtocol*/ {
    
    var topic:JSON?
//    var topicId:String?
//    var topicTitle:String?
//    var topicContent:String?
    
    @IBOutlet weak var webView: UIWebView!
 
    //let httpReq = HttpDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //设置返回按钮的图标
        var bItem = UIBarButtonItem(image: UIImage(named: "iconfont-back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backHeader")
        self.navigationItem.leftBarButtonItem = bItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        initWebView()
        
        /*
        httpReq.delegate = self
        httpReq.onHttpRequest("https://cnodejs.org/api/v1/topic/"+self.topicId!)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
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
    
    func backHeader(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backIndexList(sender: UIPanGestureRecognizer) {
        self.navigationController?.popViewControllerAnimated(true)
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
