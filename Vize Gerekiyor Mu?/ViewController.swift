//
//  ViewController.swift
//  Vize Gerekiyor Mu?
//
//  Created by Tulin Akdogan on 2/16/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

class POSTReq {
    // Instance Constants
    let URL: String = "http://vizegerekiyormu.com"
    
    // Instance variables
    var route: String
    var postString: String?
    var request: NSMutableURLRequest
    
    init(route: String, postString: String?) {
        self.route = route
        self.postString = postString
        self.request = NSMutableURLRequest(URL: NSURL(string: URL + route)!)
        self.request.HTTPMethod = "POST"
        self.request.HTTPBody = postString?.dataUsingEncoding(NSUTF8StringEncoding)
        println("inside init")
    }
    
    func makeRequest() {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(self.request, completionHandler: {(data, response, error) in
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            return self.returnResponse(responseString?)
        })
        task.resume()
    }
    
    private func returnResponse(data: NSString?) {
        var accessController = ViewController()
        switch self.route {
        case "/countries":
            var countries: NSArray = data!.componentsSeparatedByString(",")
            countries = sorted(countries, {
                (o1: AnyObject, o2: AnyObject) -> Bool in
                let s1 = o1 as NSString
                let s2 = o2 as NSString
                return  s1.intValue < s2.intValue
            })
            return countries
        case "/search":
            break
        default:
            println("none")
        }
    }
    
    func makeRequest2() {
        var bodyData = ""
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(self.request, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) in
            if error != nil {
                println("error=\(error)")
                return
            }
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("responseString = \(responseString)")
        }
    }
}


class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    let request = POSTReq(route: "/countries", postString: nil)
    let pickerData: NSArray = request.makeRequest()
    @IBAction func Search(sender: AnyObject) {
    }
    
    @IBOutlet weak var countriesPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesPicker.dataSource = self
        countriesPicker.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}
