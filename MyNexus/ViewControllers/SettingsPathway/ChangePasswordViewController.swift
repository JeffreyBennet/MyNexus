//
//  changePasswordViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/27/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController, UITextFieldDelegate{

    
  
    @IBOutlet weak var reType: UITextField!
    
  
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var error1: UILabel!
    
    @IBOutlet weak var new: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       reType.delegate = self
        new.delegate = self
     
        self.hideKeyboardWhenTappedAround()
        
        saveButton.layer.cornerRadius = 17.5
       saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func xPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func savePressed(_ sender: UIButton) {
        
        let new1 = new.text ?? ""
        let re1 = reType.text ?? ""
        print(new1)
        print(re1)
        if new1 ==  "" || re1 == ""
        {
            error1.text = "Please fill in required fields"
            error1.alpha = 1
        }
        else{
        if new1 == re1{
            Auth.auth().currentUser?.updatePassword(to: new1) { (error) in
                if let e = error{
                    
                    self.handleError(e)
                    self.error1.alpha = 1
                }
                else{
            self.error1.text = "Password succesfully changed"
            self.error1.textColor = UIColor(named: "newBlue")
            self.new.text  = ""
            self.reType.text = ""
            self.error1.alpha = 1
                }
                
            }
        }
            else {
                error1.text = "Passwords do not match"
                 error1.alpha = 1
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

extension ChangePasswordViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
          
            error1.text = errorCode.errorMessage


        }
    }
}
