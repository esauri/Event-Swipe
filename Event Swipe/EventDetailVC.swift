//
//  EventDetailVC.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/9/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import UIKit

class EventDetailVC: UITableViewController {
    var event: Event?
    let numOfSections = 6
    
    enum DetailSections: Int {
        case image = 0, name, description, startTime, endTime, viewOnWeb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = event?.name
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plainCell", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case DetailSections.image.rawValue:
            let url = URL(string: (event?.imageUrl)!)
            let data = try? Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data!)
            cell.imageView?.contentMode = UIViewContentMode.center
        case DetailSections.name.rawValue:
            cell.textLabel?.text = event?.name
        case DetailSections.description.rawValue:
            cell.textLabel?.text = event?.desc
        case DetailSections.startTime.rawValue:
            cell.textLabel?.text = event?.startTime
        case DetailSections.endTime.rawValue:
            cell.textLabel?.text = event?.endTime
        case DetailSections.viewOnWeb.rawValue:
            cell.textLabel?.text = "View on Web"
            cell.textLabel?.textColor = view.tintColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case DetailSections.viewOnWeb.rawValue:
            let url = URL(string: (event?.url)!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == DetailSections.image.rawValue) {
            return 180.0
        }
        
        return tableView.rowHeight
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
