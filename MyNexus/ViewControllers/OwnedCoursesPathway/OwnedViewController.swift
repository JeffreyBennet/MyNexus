//
//  OwnedViewController.swift
//  Calendar
//
//  Created by Jeffrey Bennet on 5/11/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//
import Firebase
import UIKit

class OwnedViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var classTableView: UITableView!
    var color = ""
    
    let db = Firestore.firestore()
    let transition = SlideinTransition()
    
    var task: [Classes] = []
    var topView: UIView?
    var nameText = ""
    var codeText = ""
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classTableView.tableFooterView = UIView()
         NotificationCenter.default.addObserver(self, selector: #selector(loadList1), name: NSNotification.Name(rawValue: "load1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList1), name: NSNotification.Name(rawValue: "load6"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList1), name: NSNotification.Name(rawValue: "load7"), object: nil)
              
       
        classTableView.dataSource = self
        classTableView.delegate = self
        classTableView.layer.borderColor = UIColor.clear.cgColor
     //   classTableView.layer.cornerRadius = 10
        classTableView.register(UINib(nibName: "OwnedClasssesCell", bundle: nil), forCellReuseIdentifier: "AnotherCell")
        
       
        
        if Constants.isNewDevice{
            if Constants.firstTimeAtOwned{
                db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").getDocuments(){
                    (querySnapshot, error) in
                    self.loadData()
                    print("her2342e")
                    Constants.firstTimeAtOwned = false
                }
            }
            else{
                print("he3rre")
                loadData()
            }
        }
        else{
            print("here")
            loadData()
        }
    }
                        
                
                
    
    
                
                
            
    
        // Do any additional setup after loading the view.
    
    func loadData(){
        db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").collection("Owned").getDocuments(source: .cache){
            (querySnapshot, error) in
            print("iyguy")
            self.task = []
            if querySnapshot!.documents.count == 0{
                self.classTableView.alpha = 0
                    
                
            }
            else{
                    self.classTableView.alpha = 1
            }
            if let snapshot = querySnapshot?.documents{
                
                for doc in snapshot{
                    let data = doc.data()
                    if let name = data["ClassName"] as? String, let c = data["Color"] as? String{
                        let code = doc.documentID
                        print(c)
                        let newClass = Classes(className: name, classCode: code, color: c)
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
    @objc func loadList1(notification: NSNotification){
           //load data here
           loadData()
       }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "toNextScreen"{
            let vc = segue.destination as! PageViewController
            vc.finalName = self.nameText
            vc.code = self.codeText
            vc.color1 = self.color
        }
        else if segue.identifier!  == "toAddSchedule"{
            return
        }
            else if segue.identifier!  == "toAdd2"{
                     return
                 }
        else{
           segue.destination.transitioningDelegate = self
        }
        
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
print("here")
            let t = task[indexPath.row]
            nameText = t.className
            codeText = t.classCode
        color = t.color
            print(codeText)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toNextScreen", sender: self)
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
                 menuViewController.modalPresentationStyle = .overCurrentContext
                 menuViewController.transitioningDelegate = self
                 present(menuViewController, animated: true)
                 
                 
    }
    

        @IBAction func addButtonPressed(_ sender: UIButton)
    {
       
    }
            
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 50
           }
        
    }
    


extension OwnedViewController  {
   

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.task.count  == 0{
          //  self.firstView.alpha = 1
           // self.firstLabel.alpha = 1
           // self.locView.alpha = 1
        }
              return task.count
          }
   
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
              let cell = tableView.dequeueReusableCell(withIdentifier: "AnotherCell", for: indexPath) as! OwnedClasssesCell
            
               let t = task[indexPath.row]
            
                  cell.className.text = t.className
            if t.className.count > 2{
              let first3 = t.className.substring(to: t.className.index(t.className.startIndex, offsetBy: 3))
              cell.three.text = first3
            }
            else{
                cell.three.text = t.className
            }
            cell.red.backgroundColor = UIColor(named: t.color)
                return cell
            
          }
    
    
}

