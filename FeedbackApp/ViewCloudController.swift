//
//  ViewCloudController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import Foundation
import UIKit

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


    }

}

