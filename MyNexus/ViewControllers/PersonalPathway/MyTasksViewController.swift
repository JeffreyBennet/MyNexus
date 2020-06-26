//
//  MyTasksViewController.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/23/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase

class MyTasksViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate  {
    let db = Firestore.firestore()
    let transition = SlideinTransition()
    var topView: UIView?
    var task: [Tasks] = []
    var nameText = ""
    var descText = ""
    var dateText = ""
    var idText = ""
    @IBOutlet weak var taskTableView: UITableView!
    
    let date = Date()
    let formatter = DateFormatter()
var dates = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MM/dd/YYYY E"
        dates = formatter.string(from: date)
        
        
     //   self.firstView.alpha = 0
         //   self.firstLabel.alpha = 0
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.estimatedRowHeight = 600
            taskTableView.dataSource = self
            taskTableView.delegate = self
            taskTableView.layer.borderColor = UIColor.clear.cgColor
            //taskTableView.layer.cornerRadius = 10
            taskTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
            
          //  reView.layer.cornerRadius = 10
            //firstView.layer.cornerRadius = 10
            loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
   
        db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").whereField("Type", isEqualTo: "Personal").whereField("Date", isGreaterThanOrEqualTo: dates).getDocuments(source: .cache){
           (querySnapshot, error) in
            if querySnapshot!.documents.count == 0{
                           print("iygededuy")
               // self.firstView.alpha = 1
             // self.firstLabel.alpha = 1
                           
                       }
            else{
              //  self.firstView.alpha = 0
               // self.firstLabel.alpha = 0
            }
           if let snapshot = querySnapshot?.documents{
            
               for doc in snapshot{
                   let data = doc.data()
                   if let title = data["Task Title"] as? String, let type = data["Type"] as? String, let desc = data["Task Description"] as? String, let date = data["Date"] as? String, let c = data["Color"] as? String{
                    let newTask = Tasks(title: title, desc: desc, date: date, type: type, docId: doc.documentID, color: c)
                       
                       self.task.append(newTask)
                       
                       DispatchQueue.main.async {
                          self.taskTableView.reloadData()
                       let indexPath = IndexPath(row: self.task.count - 1, section: 0)
                       self.taskTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                   }
               }
           }
       }
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

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
               let t = task[indexPath.row]
               nameText = t.title
               descText = t.desc
        idText = t.docId
        dateText = t.date
               tableView.deselectRow(at: indexPath, animated: true)
           performSegue(withIdentifier: "toEdit", sender: self)
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
            
            let edit = UIContextualAction(style: .normal, title: "Edit"){ (rowAction, indexPath ,complete)  in
                
                let t = self.task[row]
                self.nameText = t.title
                self.descText = t.desc
                self.idText = t.docId
                self.dateText = t.date
                self.performSegue(withIdentifier: "toEdit", sender: self)
            }
    
            let image = UIImage(systemName: "trash")
            delete.image = image
    
            let image1 = UIImage(systemName: "pencil.circle")
            edit.image = image1

        complete.backgroundColor = UIColor(named: "newGreen")
    
            let image2 = UIImage(systemName: "checkmark.circle")
            complete.image = image2
    
             return UISwipeActionsConfiguration(actions:[delete,edit, complete])
         
     }
    func deleteRow(index: IndexPath){
        let t = self.task[index.row]
        let id = t.docId
        db.collection("tasks").document(Auth.auth().currentUser?.uid ?? "").collection("currentUser").document(id).delete()
        task.remove(at: index.row)
         taskTableView.deleteRows(at: [index], with: UITableView.RowAnimation.automatic)
        if task.count == 0{
          //  self.firstView.alpha = 1
         //   self.firstLabel.alpha = 1
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "toEdit"{
            let vc = segue.destination as! EditTaskViewController
                vc.finalName = self.nameText
                vc.finalDate = self.dateText
             vc.finalDesc = self.descText
            vc.docId = self.idText
        }
            else  if segue.identifier! == "toAdd2"{
               
            }
           else  if segue.identifier! == "toAdd"{
                     
                  }
        else{
         segue.destination.transitioningDelegate = self
        }
    }
}


extension MyTasksViewController {
    
    
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
            let mySubstring1 = str[range]  // play
                cell.title.text = t.title
                cell.desc.text = t.desc
          //      cell.day.text = String(mySubstring)
             let first3 = t.date.substring(to: t.date.index(t.date.startIndex, offsetBy: 8))
                cell.date.text = first3
            //cell.taskType.text = t.type
            if t.type == "Personal"{
                cell.letter.text = "P"
                 cell.redView.backgroundColor = UIColor(named: "newBlue")
            }
            else{
                let first4 = t.type.substring(to: t.type.index(t.type.startIndex, offsetBy: 3))
                cell.letter.text = first4
                cell.redView.backgroundColor = UIColor(named: t.color)
            }
            print(String(mySubstring1))
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
              return cell
            
          }
    
    
}
