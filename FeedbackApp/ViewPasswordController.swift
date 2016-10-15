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
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewPasswordController.dismissKeyboard)))

    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
}
