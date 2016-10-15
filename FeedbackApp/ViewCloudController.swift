//
//  ViewCloudController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ViewCloudController: UIViewController {
    
    //Clouds
    @IBOutlet weak var cloud1: UIView!
    @IBOutlet weak var cloud2: UIView!
    @IBOutlet weak var cloud3: UIView!
    @IBOutlet weak var cloud4: UIView!
    @IBOutlet weak var cloud5: UIView!
    @IBOutlet weak var cloud6: UIView!
    
    //Cloud Images
    @IBOutlet weak var cloud3av: UIImageView!
    @IBOutlet weak var cloud1av: UIImageView!
    @IBOutlet weak var cloud2av: SwiftyAvatar!
    @IBOutlet weak var cloud4av: UIImageView!
    @IBOutlet weak var cloud5av: UIImageView!
    @IBOutlet weak var cloud6av: UIImageView!
    
    //Cloud Quotes
    @IBOutlet weak var cloud1txt: UITextView!
    @IBOutlet weak var cloud2txt: UITextView!
    @IBOutlet weak var cloud3txt: UITextView!
    @IBOutlet weak var cloud4txt: UITextView!
    @IBOutlet weak var cloud5txt: UITextView!
    @IBOutlet weak var cloud6txt: UITextView!
    
    //Buttons
    @IBOutlet weak var settings: UIButton!
    
    
    private var keys : [String] = []
    private var values : [String] = []
    
    private var testomonialLink: String!
    @IBOutlet weak var logo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloud1av.layer.borderWidth = 3
        cloud1av.layer.borderColor = UIColor.whiteColor().CGColor
        cloud2av.layer.borderWidth = 3
        cloud2av.layer.borderColor = UIColor.whiteColor().CGColor
        cloud3av.layer.borderWidth = 3
        cloud3av.layer.borderColor = UIColor.whiteColor().CGColor
        cloud4av.layer.borderWidth = 3
        cloud4av.layer.borderColor = UIColor.whiteColor().CGColor
        cloud5av.layer.borderWidth = 3
        cloud5av.layer.borderColor = UIColor.whiteColor().CGColor
        cloud6av.layer.borderWidth = 3
        cloud6av.layer.borderColor = UIColor.whiteColor().CGColor
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGestureRecognizer.numberOfTapsRequired = 3
        
        self.logo.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        /* Getting Testomonial Link */
        let defaults = NSUserDefaults.standardUserDefaults()
        let jsonSettings = defaults.objectForKey("jsonSettings") as? NSDictionary
        self.testomonialLink = jsonSettings?.valueForKey("TestomonialCloudLink") as? String
        
        cloud1.transform = CGAffineTransformMakeScale(0.01, 0.01)
        cloud2.transform = CGAffineTransformMakeScale(0.01, 0.01)
        cloud3.transform = CGAffineTransformMakeScale(0.01, 0.01)
        cloud4.transform = CGAffineTransformMakeScale(0.01, 0.01)
        cloud5.transform = CGAffineTransformMakeScale(0.01, 0.01)
        cloud6.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.5, delay: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.cloud1.alpha = 1.0
            self.cloud1.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.8, options: [], animations: {
            self.cloud2.alpha = 1.0
            self.cloud2.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.0, options: [], animations: {
            self.cloud3.alpha = 1.0
            self.cloud3.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.2, options: [], animations: {
            self.cloud4.alpha = 1.0
            self.cloud4.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.6, options: [], animations: {
            self.cloud5.alpha = 1.0
            self.cloud5.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.9, options: [], animations: {
            self.cloud6.alpha = 1.0
            self.cloud6.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        animateTheClouds(cloud1)
        animateTheClouds(cloud2)
        animateTheClouds(cloud3)
        animateTheClouds(cloud4)
        animateTheClouds(cloud5)
        animateTheClouds(cloud6)


    }
    
    override func viewWillAppear(animated: Bool) {
        settings.hidden = true
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
        cloud5.alpha = 0.0
        cloud6.alpha = 0.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.view.layer.removeAllAnimations()
        
        dispatch_async(dispatch_get_main_queue(), {self.cloud1.alpha = 0.0
            self.cloud2.alpha = 0.0
            self.cloud3.alpha = 0.0
            self.cloud4.alpha = 0.0
            self.cloud5.alpha = 0.0
            self.cloud6.alpha = 0.0})
        
    }
    
    
    //JSON Handler
    func jsonHandler()
    {
        // Do any additional setup after loading the view, typically from a nib.
        //URL of JSON
        let urlAsString = self.testomonialLink
        ///"https://drive.google.com/uc?export=download&id=0B2bvUUCDODywY1VRZDF3X0VQSHc"
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            do {
                if let jsonDate = data,let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonDate, options: [NSJSONReadingOptions.AllowFragments]) as? NSDictionary {
                    
                    
                    //Debug JSON Result
                    print(jsonResult["cloud1"])
                    //Debug JSON Result END
                    
                    //Get Result into Seperate Arrays
                    
                    //Cloud1
                    let cloud1quote=jsonResult["cloud1"]?.valueForKey("quote") as? String
                    let cloud1img=jsonResult["cloud1"]?.valueForKey("img") as? String
                    
                    let cloud2quote=jsonResult["cloud2"]?.valueForKey("quote") as? String
                    let cloud2img=jsonResult["cloud2"]?.valueForKey("img") as? String
                    
                    let cloud3quote=jsonResult["cloud3"]?.valueForKey("quote") as? String
                    let cloud3img=jsonResult["cloud3"]?.valueForKey("img") as? String
                    
                    let cloud4quote=jsonResult["cloud4"]?.valueForKey("quote") as? String
                    let cloud4img=jsonResult["cloud4"]?.valueForKey("img") as? String
                    
                    let cloud5quote=jsonResult["cloud5"]?.valueForKey("quote") as? String
                    let cloud5img=jsonResult["cloud5"]?.valueForKey("img") as? String
                    
                    let cloud6quote=jsonResult["cloud6"]?.valueForKey("quote") as? String
                    let cloud6img=jsonResult["cloud6"]?.valueForKey("img") as? String
                    
                    
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.cloud1txt.text = cloud1quote
                            self.cloud2txt.text = cloud2quote
                            self.cloud3txt.text = cloud3quote
                            self.cloud4txt.text = cloud4quote
                            self.cloud5txt.text = cloud5quote
                            self.cloud6txt.text = cloud6quote
                            
                            self.cloud1av.kf_setImageWithURL(NSURL(string: cloud1img!)!)
                            self.cloud2av.kf_setImageWithURL(NSURL(string: cloud2img!)!)
                            self.cloud3av.kf_setImageWithURL(NSURL(string: cloud3img!)!)
                            self.cloud4av.kf_setImageWithURL(NSURL(string: cloud4img!)!)
                            self.cloud5av.kf_setImageWithURL(NSURL(string: cloud5img!)!)
                            self.cloud6av.kf_setImageWithURL(NSURL(string: cloud6img!)!)
                            
                        }
                    }
                    
                }
            } catch let error as NSError {
                print(error)
            }
            
        })
        jsonQuery.resume()
        
    }
    //JSON Handler

    
    func animateTheClouds(cloud : UIView) {
        
        let cloudMovingSpeed = 34.4/view.frame.size.width
        let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudMovingSpeed
        UIView.animateWithDuration(NSTimeInterval(duration), delay: 0.0, options: .CurveLinear, animations: {
            cloud.frame.origin.x = self.view.frame.size.width
            }, completion: {_ in
                cloud.frame.origin.x = -self.view.frame.size.width
                self.animateTheClouds(cloud)
        })
    }
    
    func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        NSLog("3 tapped")
        settings.hidden = false
    }
    

}

