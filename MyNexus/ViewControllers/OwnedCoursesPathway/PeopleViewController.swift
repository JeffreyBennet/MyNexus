//
//  PeopleViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class PeopleViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var redView: UIImageView!
    @IBOutlet weak var membersTableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
        let db = Firestore.firestore()
    var className1 = ""
    var classCode1 = ""
    var people: [People] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        /*refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        membersTableView.addSubview(refreshControl)
 */
       // redView.layer.cornerRadius = 10
      membersTableView.dataSource = self
        membersTableView.delegate = self
        nameLabel.text = className1
       membersTableView.register(UINib(nibName: "PeopleCell", bundle: nil), forCellReuseIdentifier: "peopleCell")
        loadData()
        // Do any additional setup after loading the view.
    }
 /*   @objc func refresh(_ sender: AnyObject) {
self.refreshControl.endRefreshing()
          self.membersTableView.reloadData()
       var timeStamp = ""
       self.db.collection("Classes").document(self.classCode1).collection("JoinedUsers").whereField("TimeStamp", isEqualTo: "Deleted").getDocuments(){
       (querySnapshot, error) in
           if let snap = querySnapshot?.documents{
               for doc in snap{
                   self.db.collection("Classes").document(self.classCode1).collection("JoinedUsers").document(doc.documentID).delete()
              
               }
            DispatchQueue.main.async {
                            self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(self.classCode1).getDocument(source: .cache){
                    (document, error) in
                    if let doc = document{
                        let data = doc.data()
                        if let stamp = data?["peopleTimeStamp"] as? String{
                            timeStamp = stamp
                            DispatchQueue.main.async{
                                
                                self.db.collection("Classes").document(self.classCode1).collection("JoinedUsers").whereField("TimeStamp", isGreaterThanOrEqualTo: timeStamp).getDocuments(){
                                    (querySnapshot, error) in
                                    if let snapshot = querySnapshot?.documents{
                                        if snapshot.count > 0{
                                            self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(self.classCode1).setData(["peopleTimeStamp" : "\(Date().timeIntervalSince1970)"], merge: true)
                                        }
                                    }
                                }
                             
                             self.loadData()
                            }
                        }
                 }
                    }
                

            }
           }
       }
        
    }*/
    func loadData() {
          self.db.collection("Classes").document(classCode1).collection("JoinedUsers").getDocuments(source: .cache){
               (querySnapshot, error) in
            self.people = []
               if let snapshot = querySnapshot?.documents{
                   for doc in snapshot{
                    let data = doc.data()
                       if let name = data["Name"] as? String{
                           let newPerson = People(name: name)
                        self.people.append(newPerson)
                        DispatchQueue.main.async {
                                                                            self.membersTableView.reloadData()
                                                                         let indexPath = IndexPath(row: self.people.count - 1, section: 0)
                                                                         self.membersTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                                                     }
                       }
                   }
               }
           }
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier! == "bb"{
               
           }
    }
    @IBAction func xPressed(_ sender: UIButton) {
          _ = navigationController?.popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
}

extension PeopleViewController  {
   

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return people.count
          }
   
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
              let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleCell
            
             let t = people[indexPath.row]
            let fullName    = t.name
            let fullNameArr = fullName.components(separatedBy: " ")

            let name    = fullNameArr[0]
            let surname = fullNameArr[1]
            cell.two.text = ""
            if fullNameArr.count > 1{
                let first3 = name.substring(to: name.index(name.startIndex, offsetBy: 1))
                let first2 = surname.substring(to: surname.index(surname.startIndex, offsetBy: 1))
                cell.two.text = first3 + first2
                
            }
            else{
                let first3 = t.name.substring(to: t.name.index(t.name.startIndex, offsetBy: 1))
                cell.two.text = first3
            }
                cell.personName.text = t.name
            
              return cell
            
          }
    
    
}

