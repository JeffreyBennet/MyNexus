//
//  SignUpViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 4/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController, UITextFieldDelegate {
    let db  = Firestore.firestore()
    var error1 = ""
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
     @IBOutlet weak var GoogleSignUpButton:UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate  = self
        self.hideKeyboardWhenTappedAround()
        errorLabel.alpha = 0
        GoogleSignUpButton.layer.cornerRadius =
            20
        signUpButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        signUpButton.layer.cornerRadius = 17.5
        signUpButton.layer.borderWidth = 1
        
      NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)

        }

        @objc func didSignIn()  {
         performSegue(withIdentifier: "RegisterToChat", sender: self)
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func xPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func GooglePressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" && nameTextField.text != ""{
            errorLabel.alpha = 0
            if let email = self.emailTextField.text, let password = self.passwordTextField.text , let name = nameTextField.text{
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let e = error {
                        print(e)
                        self.handleError(e)
                        self.errorLabel.alpha = 1
                    } else {
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["TimeStamp": "\(Date().timeIntervalSince1970)","OwnedTimeStamp": "\(Date().timeIntervalSince1970)","JoinedTimeStamp": "\(Date().timeIntervalSince1970)","UUID": Auth.auth().currentUser?.uid ?? "", "Sender": email ,"Name": name, "fcmToken": ""])
                        
                            let notif = PushNotificationManager()
                        notif.updateFirestorePushTokenIfNeeded()    
                            self.performSegue(withIdentifier: "RegisterToChat" , sender: self)
                        }
                    }
                }
                
            }
            
    
            else {
                errorLabel.text = "Please fill in required fields"
                self.errorLabel.alpha = 1
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
extension SignUpViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            
            errorLabel.text = errorCode.errorMessage
            
            
        }
    }
    
    
}
