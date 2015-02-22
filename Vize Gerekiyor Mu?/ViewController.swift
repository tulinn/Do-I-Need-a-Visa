//
//  ViewController.swift
//  Vize Gerekiyor Mu?
//
//  Created by Tulin Akdogan on 2/16/15.
//  Copyright (c) 2015 Tulin Akdogan. All rights reserved.
//

import UIKit

/* Comment and Explain */
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
    
    /* Comment and Explain */
    func makeRequest(callback: (NSString) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(self.request, completionHandler: {(data, response, error) in
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            callback(responseString!)
        })
        task.resume()
    }
}

class GETReq {
    let URL: String = "http://vizegerekiyormu.com"
    
    // Instance variables
    var route: String
    var postString: String?
    var request: NSMutableURLRequest
    
    init(route: String, postString: String?) {
        self.route = route
        self.postString = postString
        self.request = NSMutableURLRequest(URL: NSURL(string: URL + route)!)
        self.request.HTTPMethod = "GET"
        self.request.HTTPBody = postString?.dataUsingEncoding(NSUTF8StringEncoding)
        println("inside init")
    }
    func makeRequest(callback: (NSString) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(self.request, completionHandler: {(data, response, error) in
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            callback(responseString!)
        })
        task.resume()
    }
}

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBAction func Search(sender: UIButton!) {/* Comment and Explain */
        selected = self.countries[countriesPicker.selectedRowInComponent(0)]
        let get_result_request = GETReq(route: ("/search/" + selected), postString: nil)
        get_result_request.makeRequest(getResult)
    }
    @IBOutlet weak var countriesPicker: UIPickerView!     /* Comment and Explain */
    
    @IBOutlet weak var Result: UILabel!
    
    func getResult(search: NSString) {
        result = search as String
        //var Result:UILabel = UILabel(frame: CGRectMake(10,100, 300, 40));
        //Result.preferredMaxLayoutWidth = self.view.bounds.width
        //Result.textAlignment = NSTextAlignment.Center;
        //Result.font = UIFont.systemFontOfSize(16.0);
        Result.text = result
        //self.view.addSubview(Result);
        
        //Result.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //Result.numberOfLines = 0
    }
    
    var theCountries: Array<String> = []
    var countries: Array<String> = []
    var countriesString: String = ""
    var selected: String = ""
    var result: String = ""
    
    private func setCountryPicker(countries: NSString) {
        countriesString = (countries as String).stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        countriesString = countriesString.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        countriesString = countriesString.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.countries = countriesString.componentsSeparatedByString(",")
        countriesPicker.dataSource = self
        countriesPicker.delegate = self
    }
    
    /* Execute on view load */
    override func viewDidAppear(animated: Bool) {
        let get_countries_request = POSTReq(route: "/countries", postString: nil)
        println("inside viewdidappear")
        get_countries_request.makeRequest(setCountryPicker)
        //Result.frame = CGRectMake(50, 150, 200, 21)
        //Result.backgroundColor = UIColor.orangeColor()
        //Result.textColor = UIColor.blackColor()
        //Result.textAlignment = NSTextAlignment.Center
        //Result.numberOfLines = 0;
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> NSString! {
        return self.countries[row] as NSString
    }
    
    //    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        myLabel.text = countries[row]
    //    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
}
