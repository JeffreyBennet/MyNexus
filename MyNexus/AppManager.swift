//
//  AppManager.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/24/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
 
class AppManager {
    let defaults = UserDefaults.standard
  static let shared = AppManager()
  private let storyboard = UIStoryboard(name: "Main", bundle: nil)
  private init() { }
    var appContainer: AppContainerViewController!
     
    func showApp() {
     
      var viewController: UIViewController
        if defaults.bool(forKey: "AgreedToTerms"){
      if Auth.auth().currentUser == nil {
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
      } else {
        viewController = storyboard.instantiateViewController(withIdentifier: "VC")
      }
            
        }
        
        else{
            viewController = storyboard.instantiateViewController(withIdentifier: "TermsTableViewController")
            
        }
      appContainer.present(viewController, animated: false, completion: nil)
     
    }
    
}
