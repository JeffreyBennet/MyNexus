//
//  LoginViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 4/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate  {
   
    
    @IBOutlet weak var GoogleSignIn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.hideKeyboardWhenTappedAround()
       errorLabel.alpha = 0
        GoogleSignIn.layer.cornerRadius = 20
        loginButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
        loginButton.layer.cornerRadius = 17.5
        loginButton.layer.borderWidth = 1
            NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)

        }

        @objc func didSignIn()  {
         performSegue(withIdentifier: "LoginToChat", sender: self)
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true)
      return false
  }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            
        }
        if let email = emailTextField.text, let password = passwordTextField.text {
               Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                   if let e = error{
                      
                    print(e._code)
                    
                    self.handleError(e)
                    
                    self.errorLabel.alpha = 1
                    return
                   } else {
                       self.performSegue(withIdentifier: "LoginToChat", sender: self)
                   }
               }
               }

        else {
        errorLabel.text = "Please fill in required fields"
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
    
    @IBAction func GooglePressed(_ sender: UIButton) {
         GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
   
    


}

extension AuthErrorCode {
var errorMessage: String {
    switch self {
    case .emailAlreadyInUse:
       return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect."
        default:
            return "Unknown error occurred"
        }
    }
    
}


extension LoginViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
          
            errorLabel.text = errorCode.errorMessage


        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
    
}
