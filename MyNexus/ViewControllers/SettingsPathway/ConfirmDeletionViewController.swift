//
//  deleteAccountViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/27/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class ConfirmDeletionViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.cornerRadius = 15
               deleteButton.layer.borderWidth = 0.8
              deleteButton.layer.borderColor = UIColor.red.cgColor
         cancelButton.layer.cornerRadius = 15
          
    
         view1.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func deletePressed(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            self.performSegue(withIdentifier: "toHome", sender: self)
          }
        }
    }
    
   
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
