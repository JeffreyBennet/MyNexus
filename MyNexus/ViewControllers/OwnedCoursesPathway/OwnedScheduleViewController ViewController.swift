//
//  OwnedScheduleViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class OwnedScheduleViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var color = ""
    var finalName1 =  ""
    var finalCode = ""
    var id = ""
    let db = Firestore.firestore()
var nameText = ""
    var descText = ""
    var dateText = ""
    let date = Date()
    let formatter = DateFormatter()
   var dates = ""
    
    @IBOutlet weak var assignmentTableView: UITableView!
    
    var task: [Assignments] = []
    
    @IBOutlet weak var scheduleNamelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignmentTableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
         NotificationCenter.default.addObserver(self, selector: #selector(loadList2), name: NSNotification.Name(rawValue: "load2"), object: nil)
    formatter.dateFormat = "MM/dd/YYYY E"
        dates = formatter.string(from: date)
        print(color)
        print("ewjfoeiwjfoiewjfe")
        scheduleNamelabel.text = finalName1
       assignmentTableView.dataSource = self
        assignmentTableView.delegate = self
        assignmentTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        if Constants.isNewDevice{
            if Constants.firstTimeAtOwnedAssignments{
                Constants.firstTimeAtOwnedAssignments = false
                
                    self.loadData()
                
            }
            else{
                loadData()
            }
        }
        else{
            loadData()
                print("ekjbfieyuguf")
            loadPeople()
            }
        
        
    }
    @objc func loadList2(notification: NSNotification){
              //load data here
              loadData()
          }
    func loadData(){
        db.collection("Assignments").document(finalCode).collection("currentAssignments").whereField("DueDate", isGreaterThanOrEqualTo: dates).getDocuments(source: .cache){
            (querySnapshot, error) in
            self.task = []
            if querySnapshot?.documents.count == 0{
                self.assignmentTableView.alpha = 0
            }
                          else
                          {
                              self.assignmentTableView.alpha = 1
                              
                          }
            if let snapshot = querySnapshot?.documents{
              
                for doc in snapshot{
                    
                    let data = doc.data()
                    if let title = data["AssignmentName"] as? String, let desc = data["AssignmentDesc"] as? String, let date = data["DueDate"] as? String{
                        let newAssignment = Assignments(assignmentName: title, assignmentDesc: desc, assignmentDate: date, docId: doc.documentID)
                        self.task.append(newAssignment)
                        DispatchQueue.main.async {
                                                      self.assignmentTableView.reloadData()
                                                   let indexPath = IndexPath(row: self.task.count - 1, section: 0)
                                                   self.assignmentTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                               }
                    }
                }
            }
        }
    }
    
    func loadPeople(){
        var timeStamp = ""
        self.db.collection("Classes").document(self.finalCode).collection("JoinedUsers").whereField("TimeStamp", isEqualTo: "Deleted").getDocuments(){
        (querySnapshot, error) in
            if let snap = querySnapshot?.documents{
                for doc in snap{
                    self.db.collection("Classes").document(self.finalCode).collection("JoinedUsers").document(doc.documentID).delete()
                }
            }
        }
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(finalCode).getDocument(source: .cache){
            (document, error) in
            if let doc = document{
                let data = doc.data()
                if let stamp = data?["peopleTimeStamp"] as? String{
                    timeStamp = stamp
                    DispatchQueue.main.async{
                        
                        self.db.collection("Classes").document(self.finalCode).collection("JoinedUsers").whereField("TimeStamp", isGreaterThanOrEqualTo: timeStamp).getDocuments(){
                            (querySnapshot, error) in
                            if let snapshot = querySnapshot?.documents{
                                if snapshot.count > 0{
                                    self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").document(self.finalCode).setData(["peopleTimeStamp" : "\(Date().timeIntervalSince1970)"], merge: true)
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let t = task[indexPath.row]
        nameText = t.assignmentName
        descText = t.assignmentDesc
        dateText = t.assignmentDate
        id = t.docId
        performSegue(withIdentifier: "makeChanges", sender: self)
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier! == "toAssign"{
        let vc = segue.destination as! CreateTaskViewController
         vc.finalCode12 = self.finalCode
        vc.finalName12 = self.finalName1
        vc.color2 = self.color
        print(finalCode)
    }
    else if segue.identifier! == "makeChanges"{
        let vc = segue.destination as! changeViewController
              vc.finalName = self.nameText
        vc.finalDesc = self.descText
        vc.finalDate = self.dateText
        vc.finalCode1 = self.finalCode
        vc.finalName2 = self.finalName1
        vc.docId = self.id
        vc.color = self.color
    }
    else if segue.identifier! == "bb"{
        
    }
    
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
         performSegue(withIdentifier: "toAssign", sender: self)
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
        
        self.tabBarController?.tabBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension OwnedScheduleViewController  {
   

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return task.count
          }
   
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

               let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
                        
                         let t = task[indexPath.row]
                        let str = t.assignmentDate
                        let index = str.index(str.endIndex, offsetBy: -3)
                        let mySubstring = str[index...] // playground
                      
                        let start = str.index(str.startIndex, offsetBy: 3)
                        let end = str.index(str.endIndex, offsetBy: -9)
                        let range = start..<end
            print(String(mySubstring))
                        let mySubstring1 = str[range]  // play
                            cell.title.text = t.assignmentName
                            cell.desc.text = t.assignmentDesc
                      //      cell.day.text = String(mySubstring)
                         let first3 = t.assignmentDate.substring(to: t.assignmentDate.index(t.assignmentDate.startIndex, offsetBy: 8))
                            cell.date.text = first3
                        //cell.taskType.text = t.type
                        
                           if finalName1.count > 2{
                                             let first4 = finalName1.substring(to: finalName1.index(finalName1.startIndex, offsetBy: 3))
                                             cell.letter.text = first4
                            }
                            else{
                                cell.letter.text = self.finalName1
                            }
                            cell.redView.backgroundColor = UIColor(named: color)
                        
                        print(String(mySubstring1))
                        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                       
                          return cell
              
            
          }
    
    
}
