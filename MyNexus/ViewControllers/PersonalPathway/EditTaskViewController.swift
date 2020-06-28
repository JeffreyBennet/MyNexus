//
//  changeViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 6/1/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class EditTaskViewController: UIViewController, UITextFieldDelegate  {
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var finalName = ""
    var finalDesc = ""
    var finalDate = ""
    var finalCode1 = ""
    var finalName2 = ""
    var docId = ""
    var dates = ""
    private var datePicker: UIDatePicker?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameLabel.text = finalName2
        deleteButton.layer.cornerRadius = 17.5
        deleteButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        saveButton.layer.cornerRadius = 17.5
        saveButton.layer.borderColor = UIColor(named: "newRed")?.cgColor
        errorLabel.alpha = 0
        nameTextField.text = finalName
        descTextField.text = finalDesc
        dateTextField.text = finalDate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeViewController.viewTapped(gestureRecognizer:)))
               dates = finalDate
               datePicker = UIDatePicker()
               datePicker?.datePickerMode = .date
               datePicker?.addTarget(self, action: #selector(changeViewController.dateChanged(datePicker:)), for: .valueChanged)
               dateTextField.inputView = datePicker
               view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil )
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
        dateFormatter.dateFormat = "MM/dd/yyyy EEE"
        dates = dateFormatter.string(from: datePicker.date)
        dateTextField.text = dateFormatter.string(from: datePicker.date)
       
        
    }
    
    @IBAction func deletPressed(_ sender: UIButton) {
        self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(self.docId).delete()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                              self.dismiss(animated: true, completion: nil)
                                                
                                            
                                        
    }
    @IBAction func savePressed(_ sender: UIButton) {
        if dateTextField.text != "" && nameTextField.text != "" && descTextField.text != "" {
            errorLabel.alpha = 0
            self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(self.docId).setData(["Task Title": nameTextField.text, "Task Description": descTextField.text!, "Date": dates],merge: true )
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                                         self.dismiss(animated: true, completion: nil)
            
        }
                else{
                    self.errorLabel.alpha = 1
                }
            
        
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
