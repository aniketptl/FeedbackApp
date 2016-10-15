//
//  ViewController.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ClientList: SearchTextField!
    @IBOutlet weak var CompanyList: SearchTextField!
    @IBOutlet weak var Comments: AutocompleteField!
    
    @IBOutlet weak var Submit: UIButton!
    @IBOutlet weak var SubmitHidden: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

