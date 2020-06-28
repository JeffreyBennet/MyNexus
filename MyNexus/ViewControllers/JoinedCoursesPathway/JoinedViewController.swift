//
//  OwnedViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/11/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit
import Firebase
class JoinedViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var bar: UIImageView!
    
    
    let transition = SlideinTransition()
       var topView: UIView?
    let db = Firestore.firestore()
    var nameText = ""
    var codeText = ""
    var color = ""
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var firstView: UIImageView!
    
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var joinedLabel: UILabel!
    var task: [Classes] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classTableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList4), name: NSNotification.Name(rawValue: "load4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList4), name: NSNotification.Name(rawValue: "load5"), object: nil)
       // backView.layer.cornerRadius = 10
       // firstView.layer.cornerRadius = 10
      //classTableView.layer.cornerRadius = 10
      //  classTableView.layer.borderColor = UIColor.clear.cgColor
      //  firstView.alpha = 0
     //   firstLabel.alpha = 0
    //    locView.alpha = 0
        classTableView.delegate = self
        classTableView.dataSource = self
//       reView.layer.cornerRadius = 10
        bar.layer.borderColor = UIColor(named: "Color")?.cgColor
        
        classTableView.register(UINib(nibName: "JoinedClassCell", bundle: nil), forCellReuseIdentifier: "Cell")
        if Constants.isNewDevice{
            if Constants.firstTimeAtJoinedCourses{
                Constants.firstTimeAtJoinedCourses = false 
                    self.loadData()
                
            }
            else{
                loadData()
            }
        }
        else{
            if Constants.firstTimeAtJoinedCourses{
                Constants.firstTimeAtJoinedCourses = false
                loadNewTasks()
            }
            else{
                
                loadData()
            }
        }
    
    }
    @objc func loadList4(notification: NSNotification){
                 //    self.classTableView.reloadData()
                 loadData()
             }
    @objc func loadList5(notification: NSNotification){
                   loadData()
                }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func loadNewTasks(){
        var timeStamp = ""
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").getDocument(source: .cache){
           (document, error) in
            if let doc = document{
                let data = doc.data()
                if let stamp = data?["JoinedTimeStamp"] as? String{
                    timeStamp = stamp
                    self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("JoinedClasses").whereField("TimeStamp", isGreaterThan: timeStamp).getDocuments(){
                        
                        (querySnapshot, error) in
                        self.loadData()
                        if querySnapshot!.documents.count > 0{
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["JoinedTimeStamp": "\(Date().timeIntervalSince1970)"])
                            
                        }
                         }
                }
            
            }
        }
     
    }
    func loadData() {
        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Joined").getDocuments(source: .cache){
        (querySnapshot, error) in
            self.task = []
            if let snapshot = querySnapshot?.documents{
                if snapshot.count == 0{
                    self.classTableView.alpha = 0
                }
                else{
                    self.classTableView.alpha = 1
                   // self.firstView.alpha = 0
                                     //  self.firstLabel.alpha = 0
                }
                for doc in snapshot{
                    let data = doc.data()
                    if let name = data["ClassName"] as? String, let color1 = data["Color"] as? String{
                        let newClass = Classes(className: name, classCode: doc.documentID, color: color1)
                        self.task.append(newClass)
                        DispatchQueue.main.async {
                            
                               self.classTableView.reloadData()
                            let indexPath = IndexPath(row: self.task.count - 1, section: 0)
                            self.classTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            
                        }
                    }
                }
            }
         }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "toJoined"{
            let vc = segue.destination as! PageViewController2
                  vc.finalName = self.nameText
                    vc.code = self.codeText
            vc.classColor = self.color
        }
            else  if segue.identifier! == "toAdd2"{
               
            }
        else if segue.identifier! == "toAdd"{
            return
                
        }
        else{
           segue.destination.transitioningDelegate = self
        }
        
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let t = task[indexPath.row]
            nameText = t.className
            codeText = t.classCode
        color = t.color
            tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toJoined", sender: self)
    }
    
   
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresenting = true
            return transition
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresenting = false
            return transition
        }
    
         
         
         
         
         
     
       

       @IBAction func didTapMenu(_ sender: UIButton) {
           guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
          // menuViewController.didTapMenuType = { menuType in
          //     self.transitionToNew(menuType)
          // }
           menuViewController.modalPresentationStyle = .overCurrentContext
           menuViewController.transitioningDelegate = self
           present(menuViewController, animated: true)
           
           
           
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



extension JoinedViewController {
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          //  firstView.alpha = 1
         //   firstLabel.alpha = 1
          //  locView.alpha = 1
        
              return task.count
          }
   
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            
            
              let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JoinedClassCell
            
             let t = task[indexPath.row]
          
                cell.className.text = t.className
            if t.className.count > 2{
            let first3 = t.className.substring(to: t.className.index(t.className.startIndex, offsetBy: 3))
              cell.three.text = first3
            }
            else{
                cell.three.text = t.className
            }
            cell.view1.backgroundColor = UIColor(named: t.color)
            //cell.three.text = first3
              return cell
            
          }
    
    
}
