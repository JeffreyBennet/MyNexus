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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return getfooterView()
    }

    func getfooterView() -> UIView
    {
        let Header = UIView(frame: CGRect(x: 0, y: 0, width: Double(self.tableView.frame.size.width), height: 45))
        Header.backgroundColor = UIColor(named: "newGray")
        let button = UIButton()
         button.frame = CGRect(x: 0, y: 0, width: Header.frame.size.width , height: Header.frame.size.height)
        button.backgroundColor = .clear
        button.setTitle("I Agree", for: .normal)
        button.setTitleColor(.link, for: .normal)
     button.addTarget(self, action: #selector(hello(sender:)), for: .touchUpInside)

        Header.addSubview(button)
        Header.bringSubviewToFront(button)
        return Header
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
        
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
