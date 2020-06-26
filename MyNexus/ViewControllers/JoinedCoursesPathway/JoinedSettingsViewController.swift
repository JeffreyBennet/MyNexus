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
        
        
        
         leaveButton.layer.cornerRadius = 17.5
                
                  leaveButton.layer.borderWidth = 1
                leaveButton.layer.borderColor = UIColor(named: "newRed")?.cgColor
                 
        nameTextField.isUserInteractionEnabled = false
        codeTextField.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func leaveButtonPressed(_ sender: UIButton) {
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").document(classCode).delete()
        db.collection("Classes").document(classCode).collection("JoinedUsers").document(Auth.auth().currentUser?.uid ?? "").setData(["TimeStamp": "Deleted"], merge: true)
        db.collection("Assignments").document(classCode).collection("currentAssignments").getDocuments(source: .cache){
            (querySnapshot, error) in
            if let snapshot = querySnapshot?.documents{
                for doc in snapshot {
                    let data = doc.data()
                    if let name = data["AssignmentsName"] as? String, let desc = data["AssignmentsDesc"] as? String, let date = data["DueDate"] as? String{
                    self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").getDocuments(source: .cache){
                        (querySnapshot, error ) in
                        if let snap = querySnapshot?.documents{
                            for d in snap {
                                let data1 = doc.data()
                                if let name1 = data1["Task Title"] as? String, let desc1 = data1["Task Description"] as? String, let date1 = data1["Date"] as? String, let type1 = data1["Type"] as? String{
                                    if name == name1 && date == date1 && desc == desc1 && type1 == self.className{
                                        self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(d.documentID).delete()
                                        
                                    }
                                    
                                }
                            }
                        }
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
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
