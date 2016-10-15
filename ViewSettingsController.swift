//
//  ViewSettingsController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import Foundation
import UIKit

class ViewSettingsController: UIViewController {
    
    @IBOutlet weak var genericList: UITextField!
    @IBOutlet weak var dateList: UITextField!
    @IBOutlet weak var testomonialCloudLink: UITextField!
    @IBOutlet weak var linkingDetailsPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Back Button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewSettingsController.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
        //End Custom Back Button
        
        //Retrieve from defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        let jsonSettings = defaults.objectForKey("jsonSettings") as? NSDictionary
        
        
        genericList.text = jsonSettings?.valueForKey("GenericListLink") as? String
        dateList.text = jsonSettings?.valueForKey("DateListLink") as? String
        testomonialCloudLink.text = jsonSettings?.valueForKey("TestomonialCloudLink") as? String
        linkingDetailsPassword.text = jsonSettings?.valueForKey("LinkingDetailsPassword") as? String
        
        jsonSettings?.valueForKey("LinkingDetailsPassword")

    }
    
    func back(sender: UIBarButtonItem) {
        //self.performSegueWithIdentifier("unwindToViewController", sender: self)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}