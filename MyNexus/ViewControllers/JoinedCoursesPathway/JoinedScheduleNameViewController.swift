//
//  JoinedScheduleNameViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/22/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase 
class JoinedScheduleNameViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    var finalName1 = ""
    var finalCode = ""
    var color = ""
    @IBOutlet weak var labelText: UILabel!
        let db = Firestore.firestore()
    var task: [Assignments] = []
    let date = Date()
     let formatter = DateFormatter()
    var dates = ""
     
    @IBOutlet weak var redName: UIImageView!
    @IBOutlet weak var assignmentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = finalName1
        print(finalCode)
         assignmentsTableView.rowHeight = UITableView.automaticDimension
         assignmentsTableView.estimatedRowHeight = 600
         formatter.dateFormat = "MM/dd/YYYY E"
             dates = formatter.string(from: date)
       // redName.layer.cornerRadius = 10
        assignmentsTableView.dataSource = self
               assignmentsTableView.delegate = self
               assignmentsTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        if Constants.isNewDevice{
            if Constants.firstTimeAtJoinedAssignments{
               
                    loadData()
                }
            
            else{
                loadData()
            }
        }
        else{
            if Constants.firstTimeAtJoinedAssignments{
                loadNewData()
            }
            else{
                loadData()
            }
        }
                   
        // Do any additional setup after loading the view.
    }
    func loadNewData(){
        var timeStamp  = ""
        print("ojeoifjeiojrioej")
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").document(finalCode).getDocument(source: .cache){
            (document, error) in
            if let doc = document{
                let data = doc.data()
                if let stamp = data?["AssignmentTimeStamp"] as? String{
                    timeStamp = stamp
                    print(timeStamp)
                    self.db.collection("Assignments").document(self.finalCode).collection("currentAssignments").whereField("TimeStamp", isGreaterThan: timeStamp).getDocuments(){
                        (querySnapshot, error) in
                        
                        if let snap = querySnapshot?.documents{
                            for doc in snap{
                                print("eferfref")
                                let data = doc.data()
                                print(data)
                            }
                            DispatchQueue.main.async {
                                self.loadData()
                            }
                            
                        }
                        if querySnapshot!.documents.count > 0{
                            self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").document(self.finalCode).setData(["AssignmentTimeStamp": "\(Date().timeIntervalSince1970)"], merge: true)
                        }
                    }
                }
            }
        }
    }
    func loadData(){
        print(dates)
        db.collection("Assignments").document(self.finalCode).collection("currentAssignments").whereField("DueDate", isGreaterThanOrEqualTo: dates).getDocuments(source: .cache){
        (querySnapshot, error) in
            self.task = []
            if let snapshot = querySnapshot?.documents{
                for doc in snapshot{
                    let data = doc.data()
                    print("eferafrefgregr")
                    if let name = data["AssignmentName"] as? String, let desc = data["AssignmentDesc"] as? String, let date = data["DueDate"] as? String{
                        let newAssignment = Assignments(assignmentName: name, assignmentDesc: desc, assignmentDate: date, docId: doc.documentID)
                        self.task.append(newAssignment)
                        
                
                        DispatchQueue.main.async {
                               self.assignmentsTableView.reloadData()
                            let indexPath = IndexPath(row: self.task.count - 1, section: 0)
                            self.assignmentsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                        
                    }
                }
            }
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func xPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

extension JoinedScheduleNameViewController  {
   

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
                        
                           return cell
          }
    
    
}
