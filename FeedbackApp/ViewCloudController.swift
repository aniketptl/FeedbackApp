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
    @IBOutlet weak var tietoLogo: UIButton!
    
    
    private var keys : [String] = []
    private var values : [String] = []
    
    private var testomonialLink: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

