//
//  CreateScheduleViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/12/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class CreateScheduleViewController: UIViewController, UITextFieldDelegate {
    var boool = false
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var classCode: UITextField!
    let db = Firestore.firestore()
    var exists1 = true
    var color = ""
    @IBOutlet weak var className: UITextField!
    let array: [String] = ["newOrange1", "newPurple", "newGreen1", "newRed"]
    override func viewDidLoad() {
        super.viewDidLoad()
        color = array.randomElement() ?? "newOrange"
        classCode.delegate = self
         className.delegate = self
          
        loginButton.layer.cornerRadius = 17.5
                loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "newBlue")?.cgColor
 errorLabel.alpha = 0
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

        

    @IBAction func createButtonPressed(_ sender: UIButton) {
        if classCode.text! != "" && className.text! != "" {
            let cc = classCode.text!
            errorLabel.text = ""
            db.collection("Classes").document(cc).getDocument(){
                (document, error) in
                if let doc = document{
                    if doc.exists{
                        self.errorLabel.text = "Class code is taken"
                        self.errorLabel.alpha = 1
                    }
                    else{
                        self.db.collection("Classes").document(cc).setData(["ClassName": self.className.text!, "Color": self.color])
                        
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(cc).setData(["ClassName": self.className.text!, "peopleTimeStamp": "\(Date().timeIntervalSince1970)",  "Color": self.color])
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load1"), object: nil)
                        self.dismiss(animated: true, completion: nil)
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

            self.db.collection("Classes").addDocument(data: ["Sender": Auth.auth().currentUser?.email, "ClassName":  self.className.text, "ClassCode":  self.classCode.text]) { (error) in
                 
                   
                    DispatchQueue.main.async {
                          self.errorLabel.alpha = 0
                     self.dismiss(animated: true, completion: nil)
                  
                    }
                }
        

}
        
 }*/
}
}
