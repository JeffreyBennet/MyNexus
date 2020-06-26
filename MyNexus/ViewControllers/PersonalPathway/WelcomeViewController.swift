//
//  WelcomeViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 4/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase
import UserNotifications

class WelcomeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate {
    let transition = SlideinTransition()
    var topView: UIView?
    
    @IBOutlet weak var firstView: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    let db = Firestore.firestore()
    @IBOutlet var calendar: FSCalendar!
    var task: [Tasks] = []
    @IBOutlet weak var taskTableView: UITableView!
    var dates = ""
    var newDate1 = ""
    let date = Date()
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.estimatedRowHeight = 600
        self.taskTableView.tableFooterView = UIView()
        formatter.dateFormat = "MM/dd/YYYY E"
        dates = formatter.string(from: date)
        print(dates)
        // calendar.layer.cornerRadius = 10
        calendar.delegate = self
        
        taskTableView.delegate = self
        //taskTableView.layer.cornerRadius = 18
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        if Constants.firstTimeNotifications{
            Constants.firstTimeNotifications = false
            let pushManager = PushNotificationManager()
            pushManager.registerForPushNotifications()
            pushManager.updateFirestorePushTokenIfNeeded()
        }
        else{
            self.loadData(date: self.dates)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulNotificationSetUp"), object: nil)
        
    }
    
    @objc func didSignIn()  {
        print("herrwfrfrefrete")
        if Constants.isNewDevice{
            print("uihiuhriuwhfuir")
            
            if Constants.firstTimeAtWelcome{
                print("rtrgrrt")
                Constants.firstTimeAtWelcome = false
                
                self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").getDocuments(){
                    (querySnapshot, error) in
                    if let snapshot = querySnapshot?.documents{
                        for doc in snapshot{
                            self.db.collection("Classes").document(doc.documentID).collection("JoinedUsers").getDocuments(){
                                (querySnapshot, error) in
                            }
                            
                            self.db.collection("Assignments").document(doc.documentID).collection("currrentAssignments").whereField("DueDate", isGreaterThanOrEqualTo: self.dates).getDocuments(){
                                (querySnapshot, error) in
                            }
                        }
                    }
                }
                
                db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").whereField("Date", isGreaterThanOrEqualTo: dates).getDocuments(){
                    (querySnapshot, error) in
                    self.loadData(date: self.dates)
                }
                self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").getDocuments(){
                    (querySnapshot, error) in
                    if let snapshot = querySnapshot?.documents{
                        for doc in snapshot{
                            
                            self.db.collection("Classes").document(doc.documentID).collection("JoinedUsers").document(Auth.auth().currentUser?.uid ?? "").setData(["fcmToken": Constants.fcmToken, "TimeStamp": Date().timeIntervalSince1970], merge: true)
                            
                            self.db.collection("Assignments").document(doc.documentID).collection("currrentAssignments").whereField("DueDate", isGreaterThanOrEqualTo: self.dates).getDocuments(){
                                (querySnapshot, error) in
                            }
                        }
                    }
                }
            }
            else{
                print("wrfouohu")
                self.loadData(date: self.dates)
            }
            
        }
        else{
            print("rtrgrrt")
            loadNewData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData(date: String){
        db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").whereField("Date", isEqualTo: dates).getDocuments(source: .cache){
            (querySnapshot, error) in
            self.task = []
            if querySnapshot!.documents.count == 0{
                self.firstView.alpha = 1
            }
            else{
                self.firstView.alpha = 0
            }
            if let snapshot = querySnapshot?.documents{
                
                for doc in snapshot{
                    let data = doc.data()
                    print("efdewfewf")
                    if let title = data["Task Title"] as? String, let type = data["Type"] as? String, let desc = data["Task Description"] as? String, let date = data["Date"] as? String,  let c = data["Color"] as? String{
                        let newTask = Tasks(title: title, desc: desc, date: date, type: type, docId: doc.documentID, color: c)
                        
                        self.task.append(newTask)
                        
                        DispatchQueue.main.async {
                            self.taskTableView.reloadData()
                            let indexPath = IndexPath(row: self.task.count - self.task.count, section: 0)
                            self.taskTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    func loadNewData(){
        var stamp = ""
        
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").getDocument(){
            (document, error) in
            if let doc = document{
                let data = doc.data()
                if let timeStamp = data?["TimeStamp"] as? String{
                    stamp = timeStamp
                    
                    self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").whereField("TimeStamp", isEqualTo: "Deleted").getDocuments(){
                        (querySnapshot, error) in
                        if let snap = querySnapshot?.documents{
                            for doc in snap{
                                self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(doc.documentID).delete()
                            }
                        }
                    }
                    
                    self.db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").whereField("TimeStamp", isGreaterThanOrEqualTo: stamp).getDocuments(){
                        (querySnapshot, error) in
                        print(self.dates)
                        print("erfrefrefref")
                        self.loadData(date: self.dates)
                        if let snapshot = querySnapshot?.documents{
                            if snapshot.count > 0{
                                self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["TimeStamp": "\(Date().timeIntervalSince1970)"], merge: true )
                                
                            }
                        }
                        
                        
                        
                        
                    }
                }
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "toSettings"{
            return
        }
        else{
            segue.destination.transitioningDelegate = self
        }
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    
    @IBAction func menuTapped(_ sender: UIButton) {
        
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = indexPath.row
        let delete = UIContextualAction(style: .destructive, title: "Delete"){ (rowAction, IndexPath,complete) in
            self.deleteRow(index: indexPath)
        }
        let complete = UIContextualAction(style: .destructive, title: "Done"){ (rowAction, IndexPath,complete) in
            
            self.deleteRow(index: indexPath)
        }
        
        
        let image = UIImage(systemName: "trash")
        delete.image = image
        
        complete.backgroundColor = UIColor(named: "newGreen")
        
        let image2 = UIImage(systemName: "checkmark.circle")
        complete.image = image2
        
        return UISwipeActionsConfiguration(actions:[delete, complete])
        
    }
    func deleteRow(index: IndexPath){
        let t = self.task[index.row]
        let id = t.docId
        db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(id).delete()
        task.remove(at: index.row)
        taskTableView.deleteRows(at: [index], with: UITableView.RowAnimation.automatic)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY E"
        dates = formatter.string(from: date)
        print(dates)
        loadData(date: dates)
        
        
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



extension WelcomeViewController: UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        
        let t = task[indexPath.row]
        let str = t.date
        let index = str.index(str.endIndex, offsetBy: -3)
        let mySubstring = str[index...] // playground
        
        let start = str.index(str.startIndex, offsetBy: 3)
        let end = str.index(str.endIndex, offsetBy: -9)
        let range = start..<end
        print(String(mySubstring))
        
        let first3 = t.date.substring(to: t.date.index(t.date.startIndex, offsetBy: 8))
        let mySubstring1 = str[range]  // play
        cell.title.text = t.title
        cell.desc.text = t.desc
        //                cell.day.text = String(mySubstring)
        
        cell.date.text = first3
        
        if t.type == "Personal"{
            cell.letter.text = "P"
            cell.redView.backgroundColor = UIColor(named: "newBlue")
        }
        else{
            if t.type.count > 2{
                
                let first4 = t.type.substring(to: t.type.index(t.type.startIndex, offsetBy: 3))
                
                cell.letter.text = first4
            }
            else{
                
                cell.letter.text = t.type
            }
            
            cell.redView.backgroundColor = UIColor(named: t.color)
        }
        print(String(mySubstring1))
        
        return cell
        
    }
    
    
}




extension UIViewController {
    @IBAction func dismissControllerAnimated() {
        dismiss(animated: true)
    }
}
