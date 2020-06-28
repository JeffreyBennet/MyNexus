//
//  OwnedSettingsViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/24/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class OwnedSettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var redView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    let db = Firestore.firestore()

    @IBOutlet weak var classCode: UITextField!
    @IBOutlet weak var className: UITextField!
    var classCode1 = ""
    var classname1 = ""
    
    @IBOutlet weak var delete: UIButton!
    
   
    @IBOutlet weak var error1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //redView.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()
       
      
        button.layer.cornerRadius = 17.5
         button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "newBlue")?.cgColor
    
        delete.layer.cornerRadius = 17.5
       delete.layer.borderWidth = 1
        delete.layer.borderColor = UIColor(named: "newRed")?.cgColor
       
        
        
        self.className.delegate = self
        self.classCode.delegate = self
        classCode.isEnabled = false
        classCode.text = classCode1
        className.text = classname1
        button.isEnabled = false
        button.alpha = 0.5
        nameLabel.text = classname1
        classCode.addTarget(self, action: #selector(OwnedSettingsViewController.textFieldDidChange(_:)), for: .editingChanged)
        className.addTarget(self, action: #selector(OwnedSettingsViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func deleted1(_ sender: UIButton) {
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(classCode1).delete()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load7"), object: nil)
        
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier! == "bb"{
           
        }
       else{
        let vc = segue.destination as! OwnedConfirmDeletionViewControllerViewController
                         vc.code = self.classCode1
                   vc.name = self.classname1
        }
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
    self.view.endEditing(true)
    classCode.endEditing(false)
     className.endEditing(true)
        
        
       return false
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        button.alpha = 1
        button.isEnabled = true
    }
    
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        button.alpha = 0.5
        button.isEnabled = false
        if classCode.text != "" && className.text != ""  {
            let newName = className.text!
            
            db.collection("Classes").document(classCode1).setData(["ClassName": newName], merge: true)
            db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(classCode1).setData(["ClassName": newName], merge: true)
            
            self.db.collection("Classes").document(classCode1).collection("JoinedUsers").getDocuments(source: .cache){
                 (querySnapshot, error) in
                 if let snapshot = querySnapshot?.documents{
                     for doc in snapshot{
                        let data = doc.data()
                         if let uid = data["uid"] as? String{
                            self.db.collection(uid).document("UserInfo").collection("Joined").document(self.classCode1).setData(["TimeStamp": "\(Date().timeIntervalSince1970)", "ClassName": newName], merge: true)
                         }
                     }
                 }
                self.error1.textColor = UIColor(named: "newBlue")
                self.error1.text = "Information saved"
                self.error1.alpha = 1
                    
             }
            }
            
        else if classCode.text == "" || className.text == "" {
            classCode.text = classCode1
            className.text = classname1
                error1.alpha = 1
                
                
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

    @IBAction func xPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load1"), object: nil)

        self.tabBarController?.tabBar.isHidden = false
         _ = navigationController?.popViewController(animated: true)
    }
    

}
