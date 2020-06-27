//
//  CreateTaskViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class CreateTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var assignmentDueDate: UITextField!
    @IBOutlet weak var assignmentDesc: UITextField!
    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var error: UILabel!
  var finalCode12 = ""
    var finalName12 = ""
    var color2 = ""
   
    var dates = ""
     let date = Date()
     let formatter = DateFormatter()
     private var datePicker: UIDatePicker?
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("kk2332")
        print(finalCode12)
        assignmentDesc.delegate = self
    assignmentName.delegate = self
        assignmentDueDate.delegate = self
        
              self.hideKeyboardWhenTappedAround()
               
        addButton.layer.cornerRadius = 17.5
            
        error.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.viewTapped(gestureRecognizer:)))
               
               datePicker = UIDatePicker()
               datePicker?.datePickerMode = .date
               datePicker?.addTarget(self, action: #selector(CreateTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
               assignmentDueDate.inputView = datePicker
               view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func xPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "xy"{
            let vc = segue.destination as! PageViewController
            vc.finalName = self.finalName12
            vc.code = self.finalCode12
            vc.color1 = color2
        }
        
        }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY E"
        dates = dateFormatter.string(from: datePicker.date)
        assignmentDueDate.text = dateFormatter.string(from: datePicker.date)
       
        
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if assignmentName.text != "" && assignmentDesc.text != "" && assignmentDueDate.text != ""{
                  
               if let taskName = assignmentName.text, let description = assignmentDesc.text, let date = assignmentDueDate.text{
                
                let dref = db.collection("Assignments").document(finalCode12).collection("currentAssignments").document()
                let id = dref.documentID
                
                dref.setData(["AssignmentName":  taskName, "AssignmentDesc": description, "DueDate": self.dates, "TimeStamp": "\(Date().timeIntervalSince1970)"]) { (error) in
                       if let e = error{
                           print(e)
                       }
                       else {
                           print("success")
                        self.db.collection("Classes").document(self.finalCode12).collection("JoinedUsers").getDocuments(source: .cache){
                            (querySnapshot, error) in
                            if let snapshot = querySnapshot?.documents{
                                for doc in snapshot{
                                    let data = doc.data()
                                    if let fcm = data["fcmToken"] as? String{
                                        let sender = PushNotificationSender()
                                        sender.sendPushNotification(to: fcm , title: self.finalName12, body: self.finalName12)
                                        let uid = doc.documentID
                                        self.db.collection("tasks").document(uid).collection("currentUser").document(id).setData(["Task Title": taskName, "Task Description": description, "Date": self.dates,"Type": self.finalName12, "TimeStamp": "\(Date().timeIntervalSince1970)", "Color": self.color2])
                                    }
                                }
                            }
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load2"), object: nil)
                                               self.dismiss(animated: true, completion: nil)
                    }
                       DispatchQueue.main.async {
                        
                           self.assignmentName.text = ""
                           self.assignmentDesc.text = ""
                           self.assignmentDueDate.text = ""
                           self.error.alpha = 0
                           
                       }
                   }
                   
               }
               }
               else {
                   error.alpha = 1
               }
    }
    
    
    
    @IBAction func prep(_ sender: UITextField) {
        print("here")
        formatter.dateFormat = "MM/dd/YYYY E"
        dates = formatter.string(from: date)
        formatter.dateFormat = "MM/dd/YYYY E"
        assignmentDueDate.text = formatter.string(from: date)

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
