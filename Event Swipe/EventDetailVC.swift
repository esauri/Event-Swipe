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
    let numOfSections = 8
    let themeColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
    let darkThemeColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
    let yellowThemeColor = UIColor(red:1.00, green:0.80, blue:0.32, alpha:1.0)
    let orangeThemeColor = UIColor(red:0.77, green:0.30, blue:0.24, alpha:1.0)
    
    // Is the event already saved
    var isEventSaved = false
    
    // index of current event in our data
    var indexOfSavedEvent = -1
    
    enum DetailSections: Int {
        case image = 0, name, description, startTime, endTime, viewOnWeb, share, save
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = event?.name
        
        self.view.backgroundColor = themeColor
        self.navigationController?.navigationBar.barTintColor = orangeThemeColor
        
        // Check if current event is saved
        if let eventExists = EventData.sharedData.savedEvents.first(where: {$0.name == event?.name}) {
            // Set bool to true
            isEventSaved = true
            
            // Save the index in case we use it
            indexOfSavedEvent = EventData.sharedData.savedEvents.index(of: eventExists)!
        }

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
            cell.textLabel?.textColor = yellowThemeColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
        case DetailSections.share.rawValue:
            cell.textLabel?.text = "Share"
            cell.textLabel?.textColor = yellowThemeColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.textAlignment = .center
        case DetailSections.save.rawValue:
            cell.textLabel?.text = (isEventSaved) ? "Remove" : "Save"
            cell.textLabel?.textColor = yellowThemeColor
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
        // If View on Web Tapped
        case DetailSections.viewOnWeb.rawValue:
            // Get url
            let url = URL(string: (event?.url)!)
            
            // Open 
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        // If share
        case DetailSections.share.rawValue:
            share()
        // If Save / Removed tapped
        case DetailSections.save.rawValue:
            if isEventSaved {
                // Remove event from array
                EventData.sharedData.savedEvents.remove(at: indexOfSavedEvent)
                
                // Event is no longer saved
                isEventSaved = false
                
                // Reset index
                indexOfSavedEvent = -1
            } else {
                // Set index of event to the total length of currently saved events
                indexOfSavedEvent = EventData.sharedData.savedEvents.count
                
                // Append event to saved events array
                EventData.sharedData.savedEvents.append(event!)
                
                // Set event to saved
                isEventSaved = true
            }
            EventData.sharedData.addSavedEventsToDisk()
            tableView.reloadData()
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

    // MARK: Share
    func share() {
        // Text
        let name = event?.name
        let textToShare = "Check out \(name ?? "this event"), cool event!"
        
        // Website
        let website = URL(string: (event?.url)!)
        
        // Image
        let imageURL = URL(string: (event?.imageUrl)!)
        let imageData = try? Data(contentsOf: imageURL!)
        let image = UIImage(data: imageData!)
        
        let objectsToShare: [AnyObject] = [textToShare as AnyObject, website! as AnyObject, image!]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.print]
        self.present(activityVC, animated: true, completion: nil)
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
