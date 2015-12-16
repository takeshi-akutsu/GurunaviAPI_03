//
//  WebViewController.swift
//  GurunaviAPI_03
//
//  Created by 阿久津岳志 on 2015/12/15.
//  Copyright © 2015年 Takeshi Akutsu. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var selectedRest: [String: String?] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        let myWebView   = WKWebView()
        myWebView.frame = self.view.frame
        self.view.addSubview(myWebView)
        
        let url = self.selectedRest["url"]!
        let myURL = NSURL(string: url!)
        let myURLReq = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLReq)
        
        myWebView.navigationDelegate = self
    
    }
    
    //Webページの読み込みが開始したタイミングで、インジケータを表示
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    //Webページの読み込みが完了したタイミングで、インジケータを非表示
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
