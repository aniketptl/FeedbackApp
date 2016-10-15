//
//  ViewController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ScrollView: UIScrollView!

    /* Text Fields */
    @IBOutlet weak var ClientList: SearchTextField!
    @IBOutlet weak var CompanyList: SearchTextField!
    @IBOutlet weak var Comments: AutocompleteField!
    
    /* Buttons */
    @IBOutlet weak var Submit: UIButton!
    @IBOutlet weak var SubmitHidden: UIButton!
    
    /* List of Links */
    private var GenericListLink : String!
    private var DateListLink: String!
    private var SettingsLink: String!
    
    /* Google Form Connection */
    private var googleFormLink: String!
    private var googleFormNameField: String!
    private var googleFormCompanyField: String!
    private var googleFormCommentsField: String!
    
    private var tap: UITapGestureRecognizer!
    private var todayStringDate:String = ""
    private var urlAsString : String!
    private var jsonSettings:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submit(sender: AnyObject) {
    }
    @IBAction func submitHidden(sender: AnyObject) {
    }
    
    //JSON Handler
    func jsonHandler()
    {
        // Do any additional setup after loading the view, typically from a nib.
        //URL of JSON
        self.urlAsString = self.DateListLink
        dispatch_async(dispatch_get_main_queue()) {
            let url = NSURL(string: self.urlAsString)!
            let urlSession = NSURLSession.sharedSession()
            
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                do {
                    if let jsonDate = data,let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonDate, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary {
                        
                        print(self.urlAsString)
                        
                        //Deal with Today's Date and put it into Format
                        let todayDate=NSDate();
                        let dateformmater=NSDateFormatter();
                        dateformmater.timeZone=NSTimeZone(name: "UTC");
                        dateformmater.locale=NSLocale.currentLocale()
                        dateformmater.dateFormat="dd/MM/YYYY"
                        self.todayStringDate = dateformmater.stringFromDate(todayDate)
                        
                        //self.todayStringDate = "15/08/2016"
 
                        
                        //Debug JSON Result
                        print(jsonResult)
                        //Debug JSON Result END
                        
                        //Get Result into Seperate Arrays
                        let keys=jsonResult[self.todayStringDate]?.allKeys as? [String];
                        let values=jsonResult[self.todayStringDate]?.allValues as? [String];
                        
                        
                        if(keys?.isEmpty ?? true && values?.isEmpty ?? true)
                        {
                            print("No Data for today")
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                                    UIAlertAction in
                                    NSLog("Cancel Pressed")
                                }
                                
                                let alert = UIAlertController(title: "Message", message: "No Data Present For Today , Suggestions will be off", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Switch Generic List", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                                    /* Handle Generic List Here */
                                }));
                                
                                alert.addAction(cancelAction)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            
                        }
                        else
                        {
                            //Get Unique Values to Avoid Repeatation
                            let uniqueValues = Array(Set(values!))
                            
                            //Set the List
                            self.ClientList.filterStrings(keys!)
                            self.CompanyList.filterStrings(uniqueValues)
                            
                            //List Selection Handler
                            //Handle List
                            
                            self.ClientList.itemSelectionHandler = {item in
                                let title = item.title
                                print("Title Name of List = "+title)
                                self.ClientList.text=title
                                self.CompanyList.text = jsonResult[self.todayStringDate]!.valueForKey(title) as? String
                                self.ScrollView.setContentOffset(CGPointMake(0,230), animated: true)
                                
                            }
                            
                            self.CompanyList.itemSelectionHandler = {item in
                                let title = item.title
                                print("Title Name of Company = "+title)
                                self.CompanyList.text=title
                            }
                        }
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
                
            })
            jsonQuery.resume()
        }
        
    }
    //JSON Handler
    
    //Settings Generic JSON
    func settingsJsonHandler()
    {
        // Do any additional setup after loading the view, typically from a nib.
        //URL of JSON
        
        
        
        let startime = NSDate()
        print(startime)
        
        let semaphore = dispatch_semaphore_create(0)
        self.urlAsString = self.SettingsLink
        
        let url = NSURL(string: self.urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            do {
                if let jsonDate = data,let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonDate, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary {
                    
                    print(self.urlAsString)
                    
                    
                    //Debug JSON Result
                    print("Settings")
                    print(jsonResult)
                    //Debug JSON Result END
                    
                    self.jsonSettings=jsonResult;
                    
                    //Get Result into Seperate Arrays
                    let keys=jsonResult.allKeys as? [String];
                    let values=jsonResult.allValues as? [String];
                    
                    
                    if(keys?.isEmpty ?? true && values?.isEmpty ?? true)
                    {
                        print("No Generic Data for today")
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                                UIAlertAction in
                                NSLog("Cancel Pressed")
                            }
                            
                            let alert = UIAlertController(title: "Message", message: "Settings JSON Does't Exist or Internet is not working Please check Link", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addAction(cancelAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    else
                    {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        
                        //Set Lists Link
                        self.GenericListLink = jsonResult.valueForKey("GenericListLink") as? String
                        self.DateListLink = jsonResult.valueForKey("DateListLink") as? String
                        
                        //Set Google Form Link
                        self.googleFormLink = jsonResult.valueForKey("GoogleFormLink") as? String
                        self.googleFormNameField = jsonResult.valueForKey("GoogleFormNameField") as? String
                        self.googleFormCompanyField = jsonResult.valueForKey("GoogleFormCompanyField") as? String
                        self.googleFormCommentsField = jsonResult.valueForKey("GoogleFormCommentsField")as? String
                        
                        
                        //Put into Default Settings Object to use it anywhere
                        defaults.setObject(self.jsonSettings, forKey:"jsonSettings" )
                    }
                    
                }
            } catch let error as NSError {
                print(error)
            }
            dispatch_semaphore_signal(semaphore)
            
        })
        jsonQuery.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        let tartime = NSDate()
        print(tartime)
        
    }
    //Settings Generic JSON


}

