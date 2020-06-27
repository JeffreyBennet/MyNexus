//
//  TermsTableViewController.swift
//  MyNexus
//
//  Created by Jeffrey Bennet on 6/26/20.
//  Copyright © 2020 Jeffrey Bennet. All rights reserved.
//

import UIKit

class TermsTableViewController: UITableViewController {
let defaults = UserDefaults.standard
    var height = ""
    var bool = true
    let screenRect = UIScreen.main.bounds
    var screenWidth  = 0.0
    var screenHeight = 0.0
    var h = 0
    var x = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      screenWidth = Double(screenRect.size.width)
        screenHeight = Double(screenRect.size.height)
print(screenHeight)
        if bool{
            x = 45
        }
        else{
            x = 70
        }
        
        if screenHeight <= 667{
            h = 45
        }
        else {
            h = 60
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return getfooterView()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getfooter1View()
    }
    func getfooter1View() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: Double(x)))
        
        if !bool{
            Header.backgroundColor = UIColor(named: "newGray")
            let button = UIButton()
                button.frame = CGRect(x:30 , y: 10, width: 40 , height: Header.frame.size.height)
               button.backgroundColor = .clear
            button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
               button.setTitleColor(.link, for: .normal)
            button.addTarget(self, action: #selector(hello1(sender:)), for: .touchUpInside)
            Header.addSubview(button)
            Header.bringSubviewToFront(button)

            return Header
        }
        else{
            Header.backgroundColor = UIColor.white
        return Header
        }
    }
    func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: Double(h)))
        Header.backgroundColor = UIColor(named: "newGray")
        let button = UIButton()
         button.frame = CGRect(x: 0, y: 0, width: Header.frame.size.width , height: Header.frame.size.height-10)
        button.backgroundColor = .clear
        button.setTitle("I Agree", for: .normal)
        button.setTitleColor(.link, for: .normal)
     button.addTarget(self, action: #selector(hello(sender:)), for: .touchUpInside)

        Header.addSubview(button)
        Header.bringSubviewToFront(button)
        return Header
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if bool{
        if screenHeight <= 667.0{
            return 45
        }
        else{
        return 70
        }
        }
        else{
            return 0
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if bool{
          return 45
        }
        else{
            return 70
        }
      }
    @objc func hello1(sender: UIButton!) {
     self.dismiss(animated: true, completion: nil)

    }
    @objc func hello(sender: UIButton!) {
        defaults.set(true, forKey: "AgreedToTerms")
    performSegue(withIdentifier: "xx", sender: self)

    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
