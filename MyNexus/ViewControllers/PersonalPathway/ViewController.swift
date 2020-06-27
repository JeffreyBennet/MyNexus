//
//  ViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 4/21/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    

    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
       // loginButton.layer.borderWidth = 2
       loginButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        
         
            loginButton.layer.cornerRadius = 20
            signUpButton.layer.cornerRadius = 20
            loginButton.layer.borderWidth = 1
            signUpButton.layer.borderWidth = 1
        
      //  signUpButton.layer.borderWidth = 2
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    
    
}

