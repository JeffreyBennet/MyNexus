//
//  OwnedConfirmDeletionViewControllerViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/24/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class OwnedConfirmDeletionViewControllerViewController: UIViewController {
    let db = Firestore.firestore()

        var code = ""
    var name = ""
    @IBOutlet weak var view1: UIView!
    
  
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       deleteButton.layer.cornerRadius = 10
              deleteButton.layer.borderWidth = 0.8
             deleteButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 10
         cancelButton.layer.borderWidth = 0.8
       cancelButton.layer.borderColor = UIColor.clear.cgColor
        view1.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deletePressde(_ sender: UIButton) {
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(code).delete()
        
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
