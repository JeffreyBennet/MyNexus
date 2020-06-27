//
//  AddTaskViewController.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class AddTaskViewController: UIViewController, UITextFieldDelegate {
    let formatter = DateFormatter()
    @IBOutlet weak var error: UILabel!
    let db = Firestore.firestore()
    private var datePicker: UIDatePicker?
    @IBOutlet weak var nameTextField: UITextField!
    let date = Date()
    @IBOutlet weak var descTextField: UITextField!
    var dates = ""
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dueDateTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
         descTextField.delegate = self
        dueDateTextField.delegate = self
        addButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        addButton.layer.cornerRadius = 17.5
        addButton.layer.borderWidth = 1
        self.hideKeyboardWhenTappedAround()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTaskViewController.viewTapped(gestureRecognizer:)))
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        dueDateTextField.inputView = datePicker
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func xPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if nameTextField.text != "" && descTextField.text != "" && dueDateTextField.text != ""{
                
             if let messageSender = Auth.auth().currentUser?.email, let taskName = nameTextField.text, let description = descTextField.text{
                
                db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").addDocument(data: ["Task Title": taskName, "Task Description": description, "Date": dates, "Type": "Personal","TimeStamp": "\(Date().timeIntervalSince1970)","Color": "newBlue"]) { (error) in
                     if let e = error{
                         print(e)
                     }
                     else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                         self.dismiss(animated: true, completion: nil)
                     }
                     DispatchQueue.main.async {
                        
                         self.nameTextField.text = ""
                         self.descTextField.text = ""
                         self.dueDateTextField.text = ""
                         self.error.alpha = 0
                         
                     }
                 }
                 
             }
             }
             else {
                 error.alpha = 1
             }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return false
      }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy E"
        dates = dateFormatter1.string(from: datePicker.date)
        dateFormatter.dateFormat = "MM/dd/yyyyE"
        dueDateTextField.text = dateFormatter.string(from: datePicker.date)
       
        
    }
    
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func prep(_ sender: UITextField) {
        formatter.dateFormat = "MM/dd/YYYY EEE"
        dates = formatter.string(from: date)
        formatter.dateFormat = "MM/dd/YYYY E"
        dueDateTextField.text = formatter.string(from: date)
    }
}
