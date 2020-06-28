//
//  JoinScheduleViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/17/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class JoinScheduleViewController: UIViewController, UITextFieldDelegate {
        let db = Firestore.firestore()

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let dates = ""
    var exists1 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
         
        self.hideKeyboardWhenTappedAround() 
        loginButton.layer.cornerRadius = 17.5
         loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        
       codeTextField.delegate = self
        
        errorLabel.alpha = 0
                
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
   
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func joinTapped(_ sender: UIButton) {
        if codeTextField.text != "" {
            db.collection("Classes").document(codeTextField.text!).getDocument(){
                (document, error) in
                if let doc = document{
                    let data = doc.data()
                    
                    if doc.exists{
                        let name = data!["ClassName"] as! String
                        self.db.collection("Classes").document(self.codeTextField.text!).collection("JoinedUsers").document(Auth.auth().currentUser?.uid ?? "").setData(["fcmToken": Constants.fcmToken, "Name": Constants.name, "TimeStamp": "\(Date().timeIntervalSince1970)"])
                        
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").document(self.codeTextField.text!).setData(["ClassName": data!["ClassName"] as! String, "TimeStamp": "\(Date().timeIntervalSince1970)","AssignmentTimeStamp":"\(Date().timeIntervalSince1970)", "Color": data!["Color"] as! String])
                            
                        self.db.collection("Assignments").document(self.codeTextField.text!).collection("currentAssignments").getDocuments(){
                            (querySnapshot,error) in
                            if let snapshot = querySnapshot?.documents{
                                for doc in snapshot{
                                    print("rfirjfoi")
                                    let data1 = doc.data()
                                    let id = doc.documentID
                                    print(id)
                                      let dref =  self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(id)
                                    dref.setData(["Task Title": data1["AssignmentName"] as! String, "Task Description": data1["AssignmentDesc"] as! String, "Date": data1["DueDate"] as! String,"TimeStamp": "\(Date().timeIntervalSince1970)", "Type": name, "Color": data!["Color"] as! String])
                                        
                                        
                                    
                                }
                            }
                        }
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load4"), object: nil)
                          self.dismiss(animated: true, completion: nil)

                        self.tabBarController?.tabBar.isHidden = false
                    }
                    else{
                        self.errorLabel.text = "Class code does not exist"
                        self.errorLabel.alpha = 1
                    }
                }
            }
        }
        else {
                   errorLabel.text = "Please fill in required fields"
                   errorLabel.alpha = 1
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
}
