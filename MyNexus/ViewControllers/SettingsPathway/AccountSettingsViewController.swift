//
//  AccountSettingsViewController.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class AccountSettingsViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
   var name = ""
   var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        saveChangesButton.layer.cornerRadius = 17.5
        saveChangesButton.isEnabled = false
        saveChangesButton.alpha = 0.5
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").getDocument(source: .cache){
            (document, error) in
            if let doc = document{
                let data = doc.data()
                if let n = data?["Name"] as? String, let e = data?["Sender"] as? String{
                    self.name = n
                    self.email = e
                    self.nameTextField.text = self.name
                    self.emailTextField.text = self.email
                }
            }
        }
          self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        saveChangesButton.isEnabled = true
        saveChangesButton.alpha = 1
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if nameTextField.text == "" {
            nameTextField.text = name
            saveChangesButton.isEnabled = false
            saveChangesButton.alpha = 0.5
        }
        if emailTextField.text == ""{
            emailTextField.text = email
            saveChangesButton.isEnabled = false
            saveChangesButton.alpha = 0.5
        }
        
        if emailTextField.text != email || nameTextField.text != name{
            if emailTextField.text == email{
                db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["Name": nameTextField.text!], merge: true)
                self.errorLabel.alpha = 1
                  self.errorLabel.textColor = UIColor(named: "newBlue")
                self.errorLabel.text = "Information changed!"
                Constants.name = self.nameTextField.text!
                saveChangesButton.isEnabled = false
                saveChangesButton.alpha = 0.5
            }
            else{
                Auth.auth().fetchProviders(forEmail: emailTextField.text!, completion: {
                    (providers, error) in
                    if let error = error {
                        
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["Name": self.nameTextField.text!, "Sender": self.emailTextField.text!], merge: true)
                        self.errorLabel.alpha = 1
                        Constants.name = self.nameTextField.text!
                         self.errorLabel.textColor = UIColor(named: "newBlue")
                       self.errorLabel.text = "Information changed!"
                        self.saveChangesButton.isEnabled = false
                        self.saveChangesButton.alpha = 0.5
                        
                    } else if let providers = providers {
                        self.errorLabel.alpha = 1
                        self.errorLabel.textColor = UIColor(named: "newRed")
                        self.errorLabel.text = "Email is already in use by another user"
                        self.saveChangesButton.isEnabled = false
                        self.saveChangesButton.alpha = 0.5
                        
                    }
                })
            }
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
