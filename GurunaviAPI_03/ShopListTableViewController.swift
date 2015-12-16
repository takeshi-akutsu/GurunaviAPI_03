//
//  ShopListTableViewController.swift
//  GurunaviAPI_03
//
//  Created by 阿久津岳志 on 2015/12/15.
//  Copyright © 2015年 Takeshi Akutsu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopListTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!

    var rests: [[String: String?]] = []
    
    var selectedRest: [String: String?] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        let rest = self.rests[indexPath.row]
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = rest["name"]!
        
        let imageView = cell.viewWithTag(2) as! UIImageView
        let imageString = rest["image"]!
        if let unwrappedImageString = imageString {
            let myURL = NSURL(string: unwrappedImageString)
            let myData = NSData(contentsOfURL: myURL!)
            let myImage = UIImage(data: myData!)
            imageView.image = myImage
        } else {
            imageView.image = UIImage(named: "default_image.png")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRest = self.rests[indexPath.row]
        self.performSegueWithIdentifier("ShowWebViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webViewController = segue.destinationViewController as! WebViewController
        webViewController.selectedRest = self.selectedRest
    }

    func getData() {
        let str = textField.text!
        let encodeStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url: URLStringConvertible = "http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=c7c388454072d51027a3ab1134d37073&format=json&name=" + encodeStr!
        Alamofire.request(.GET, url)
            .responseJSON { (response) -> Void in
                guard let object = response.result.value else {
                    return
                }
                let objectJson = JSON(object)
                let restJson = objectJson["rest"]
                self.rests = []
                restJson.forEach({ (_,rest) -> () in
                    let imageDic = rest["image_url"]
                    let rest:[String: String?] = [
                        "name": rest["name"].string,
                        "url": rest["url"].string,
                        "image": imageDic["shop_image1"].string
                    ]
                    self.rests.append(rest)
                })
                self.tableView.reloadData()
                
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.getData()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapSearchButton(sender: UIBarButtonItem) {
        self.getData()
    }
}
