//
//  SavedEventsTableVC.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/9/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import UIKit

class SavedEventsTableVC: UITableViewController {
    let themeColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
    let darkThemeColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
    let orangeThemeColor = UIColor(red:0.77, green:0.30, blue:0.24, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.view.backgroundColor = themeColor
        self.navigationController?.navigationBar.barTintColor = orangeThemeColor
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Reload table when we go back to this screen
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EventData.sharedData.savedEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedEventsCell", for: indexPath)

        // Configure the cell...
        let event = EventData.sharedData.savedEvents[indexPath.row]
        cell.textLabel?.text = event.name
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            EventData.sharedData.savedEvents.remove(at: indexPath.row)
            EventData.sharedData.addSavedEventsToDisk()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let eventToMove = EventData.sharedData.savedEvents.remove(at: fromIndexPath.row)
        EventData.sharedData.savedEvents.insert(eventToMove, at: to.row)
        EventData.sharedData.addSavedEventsToDisk()
    }
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            
            guard selectedRow < EventData.sharedData.savedEvents.count else {
                print("Row \(selectedRow) is not in saved events")
                return
            }
            
            let detailVC = segue.destination as! EventDetailVC
            detailVC.event = EventData.sharedData.savedEvents[selectedRow]
        }
    }
}

