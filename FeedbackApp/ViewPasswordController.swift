//
//  ViewPasswordController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import Foundation
import UIKit

class ViewPasswordController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var enterCorrectPass: UILabel!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    private var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Back Button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewSettingsController.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
        //End Custom Back Button
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewPasswordController.dismissKeyboard)))
        
        login.layer.cornerRadius=6;
        enterCorrectPass.hidden = true
        password.borderStyle=UITextBorderStyle.RoundedRect

    }
    
    override func viewDidAppear(animated: Bool) {
        password.text = nil
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let jsonSettings = defaults.objectForKey("jsonSettings") as? NSDictionary
        
        //Total Unsecure Way :P currently
        let passwd = jsonSettings?.valueForKey("LinkingDetailsPassword") as? String
        print(jsonSettings)
        
        if(password.text == passwd )
        {
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewSettingsController") as! ViewSettingsController
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }
        else
        {
            enterCorrectPass.hidden = false
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.ScrollView.setContentOffset(CGPointMake(0,230), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.ScrollView.setContentOffset(CGPointMake(0,0), animated: true)
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func back(sender: UIBarButtonItem) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    
}
