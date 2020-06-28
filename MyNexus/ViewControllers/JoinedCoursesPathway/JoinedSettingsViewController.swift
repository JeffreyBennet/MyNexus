//
//  JoinedSettingsViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class JoinedSettingsViewController: UIViewController {
    var className = ""
    var classCode = ""
    let db = Firestore.firestore()
    @IBOutlet weak var redView: UIImageView!
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        classNameLabel.text = className
        nameTextField.text = className
        codeTextField.text = classCode
       // redView.layer.cornerRadius = 10
        
        
        
        self.tabBarController?.tabBar.isHidden = true
         leaveButton.layer.cornerRadius = 17.5
                
                  leaveButton.layer.borderWidth = 1
                leaveButton.layer.borderColor = UIColor(named: "newRed")?.cgColor
                 
        nameTextField.isUserInteractionEnabled = false
        codeTextField.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func leaveButtonPressed(_ sender: UIButton) {
        
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").document(classCode).delete()
       DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load5"), object: nil)
                  _ = self.navigationController?.popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
       }
        db.collection("Classes").document(classCode).collection("JoinedUsers").document(Auth.auth().currentUser?.uid ?? "").setData(["TimeStamp": "Deleted"], merge: true)
       
        db.collection("Assignments").document(classCode).collection("currentAssignments").getDocuments(source: .cache){
            (querySnapshot, error) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load10"), object: nil)
            if let snapshot = querySnapshot?.documents{
                for doc in snapshot {
                    self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(doc.documentID).delete()
                }
            }
        }
        
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
            _ = navigationController?.popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
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
