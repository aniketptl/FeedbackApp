//
//  ViewController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate{
    
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
    @IBOutlet weak var indicator: activityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Reachability. Basically checks internet connectivity */
        let status = Reach().connectionStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        /* Keyboard Handling */
        self.tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.tap.delegate = self
        self.view.addGestureRecognizer(self.tap)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.settingsJsonHandler()
        SubmitHidden.alpha = 0.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if(isViewLoaded())
        {
            indicator.hidesWhenCompleted=true;
            indicator.completeLoading(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submit(sender: AnyObject) {
        
        if ((ClientList.text?.isEmpty) != false){
            view.makeToast(message: "Please Enter Your Name")
        }
        else
        {
            animatebutton(Submit)
            sendToGoogleForm()
            setTextFieldNull()
            view.makeToast(message: "Feedback Submitted")
        }

    }
    @IBAction func submitHidden(sender: AnyObject) {
        
        if ((ClientList.text?.isEmpty) != false)
        {
            view.makeToast(message: "Please Enter Your Name",duration:2.0,position:HRToastPositionTop)
        }
        else
        {
            animatebutton(SubmitHidden)
            sendToGoogleForm()
            setTextFieldNull()
            view.makeToast(message: "Feedback Submitted", duration: 2.0, position:HRToastPositionTop )
        }
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func setTextFieldNull()
    {
        ClientList.text=nil;
        CompanyList.text=nil;
        Comments.text=nil;
    }
    
    
    func animatebutton(button:UIButton)
    {
        button.transform = CGAffineTransformMakeScale(0.6, 0.6)
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 2.2,
                                   initialSpringVelocity: 0.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        print(userInfo)
        
        let status = Reach().connectionStatus()
        print(status)
        
        switch status {
        case .Unknown, .Offline:
            print("Not connected")
            let alert = UIAlertController(title: "Message", message: "Please Connect to Internet", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case .Online(.WWAN):
            print("Connected via WWAN")
            self.dismissViewControllerAnimated(false, completion: nil)
            self.jsonHandler()
            
            
        case .Online(.WiFi):
            print("Connected via WiFi")
            self.dismissViewControllerAnimated(false, completion: nil)
            self.jsonHandler()
        }
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
    
    //Switch Generic JSON
    func switchGenericJsonHandler()
    {
        
        indicator.startLoading();
        
        // Do any additional setup after loading the view, typically from a nib.
        //URL of JSON
        
        print("Generitc List")
        urlAsString = GenericListLink;
        
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            do {
                if let jsonDate = data,let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonDate, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary {
                    
                    print(self.urlAsString)
                    
                    //Debug JSON Result
                    print(jsonResult)
                    //Debug JSON Result END
                    
                    //Get Result into Seperate Arrays
                    let keys=jsonResult.allKeys as? [String];
                    let values=jsonResult.allValues as? [String];
                    
                    
                    if(keys?.isEmpty ?? true && values?.isEmpty ?? true)
                    {
                        print("No Generic Data for today")
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let alert = UIAlertController(title: "Message", message: "Generic List Doesn't Have Data or Check Internet", preferredStyle: UIAlertControllerStyle.Alert)
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
                            self.CompanyList.text = jsonResult.valueForKey(title) as? String
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
        
        indicator.completeLoading(true)
    }
    //END Switch Generic JSON

    
    //Send To Google Form
    func sendToGoogleForm()
    {
        let url = NSURL(string: googleFormLink)
        var postData = googleFormNameField + "="+ClientList.text!
        postData += "&" + googleFormCompanyField + "="+CompanyList.text!
        postData += "&" + googleFormCommentsField + "="+Comments.text!
        
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        _ = NSURLConnection(request: request, delegate: nil, startImmediately: true)
    }
    //Send To Google Form End
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /* Sets text from autocomplete when pressing return */
        if let field = textField as? AutocompleteField
        {
            field.text = field.suggestion
        }
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        
        if touch.view != nil && touch.view!.isDescendantOfView(self.ClientList.tableView!)
        {
            return false
        }
        
        if touch.view != nil && touch.view!.isDescendantOfView(self.CompanyList.tableView!)
        {
            return false
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField==Comments)
        {
            ScrollView.setContentOffset(CGPointMake(0,250), animated: true)
            
            SubmitHidden.alpha = 1.0
            SubmitHidden.transform = CGAffineTransformMakeScale(0.01, 0.01)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.SubmitHidden.alpha = 1.0
                self.SubmitHidden.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            Submit.alpha = 0.0
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        ScrollView.setContentOffset(CGPointMake(0,0), animated: true)
        
        if (textField == Comments) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.SubmitHidden.alpha = 0.0
                }, completion: nil)
            Submit.alpha = 1.0
        }
    }


}

