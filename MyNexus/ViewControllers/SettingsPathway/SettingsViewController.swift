//
//  SettingsViewController.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func logOutPressed(_ sender: Any) {
           
             let firebaseAuth = Auth.auth()
           do {
             try firebaseAuth.signOut()
                performSegue(withIdentifier: "logOut", sender: self)
           } catch let signOutError as NSError {
             print ("Error signing out: %@", signOutError)
           }
             
       }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ww"{
            let vc = segue.destination as! TermsTableViewController
            vc.bool = false
        }
    }
    

}
