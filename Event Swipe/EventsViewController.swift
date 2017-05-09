//
//  EventsViewController.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/1/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    /////////////////////// Eventbrite
    let EVENTBRITE_TOKEN = "63H4B3WRGIQUMQMUX563"
    let EVENT_SEARCH_URL = "https://www.eventbriteapi.com/v3/events/search/?token="
    let TEST_CITY = "Rochester"
    
    /////////////////////// Data Fetching
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var eventResults = [String]() // empty array of strings
    var nearbyEvents: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getEventResults(city: TEST_CITY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Card View
    func loadCardView() {
        // Create a Card View
        let cardView = CardView(frame: self.view.frame)
        
        // Pass in the events
        cardView.events = nearbyEvents
        
        // Load the card view
        cardView.loadView()
        
        // Add subview
        self.view.addSubview(cardView)
    }
    
    // MARK: Helpers
    
    // Doing it by address for now
    func getEventResults(city: String) {
        // Make srue there the search terms have characters
        let cityValidation = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cityValidation.isEmpty == false else {
            return
        }
        
        // If there is a dataTask kill it
        if let dataTask = dataTask {
            dataTask.cancel()
        }
        
        let urlString = "\(EVENT_SEARCH_URL)\(EVENTBRITE_TOKEN)&location.address=\(city)"
        guard let url = URL(string: urlString) else {
            print("something is wrong with the url")
            return
        }
        
        // Start the build-in spinner in the status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Now that we have an url so start downloading data
        dataTask = defaultSession.dataTask(with: url as URL) {
            data, response, error in
            
            // Here we are calling our UI code on main thread so that it works consistently
            DispatchQueue.main.async {
                // Hide the spinner
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                // If there is an error, print it
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    // Otherwise pass the download data along
                    if httpResponse.statusCode == 200 {
                        self.updateEventResults(data)
                    }
                } // end if error
            } // end closure we are calling on main thread
        } // end dataTask closure
        
        // Start the download with resume()
        dataTask?.resume()
    }

    func updateEventResults(_ data: Data?) {
        // Clear old data
        eventResults.removeAll()
        
        do {
            if let data = data, let responseDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] {
                
                // 
                guard let eventsArray: AnyObject = responseDictionary["events"] else {
                    print("Results don't have an 'events' key")
                    return
                }
                
                for eventObject in eventsArray as! [AnyObject] {
                    guard let eventObject = eventObject as? [String: AnyObject] else {
                        print("Not a dictionary - bail out!")
                        return
                    }
                    
                    ///
                    let id = eventObject["id"] as? Int ?? 0
                    let name = eventObject["name"]?["text"] as? String ?? "Unknown event"
                    let desc = eventObject["description"]?["text"] as? String ?? "\(name) description not available."
                    let url = eventObject["url"] as? String ?? "https://www.eventbrite.com"
                    let imageUrl = eventObject["logo"]?["url"] as? String ?? "http://images.gawker.com/zxpvsmndjrroklechbz4/original.gif"
                    let categoryId = eventObject["category_id"] as? Int ?? 0
                    let subCategoryId = eventObject["subcategory_id"] as? Int ?? 0
                    let startTimeObject = eventObject["start"]
                    let endTimeObject = eventObject["end"]
                    let startTime = startTimeObject?["local"] as? String ?? "Start date unknown"
                    let endTime = endTimeObject?["local"] as? String ?? "End date unknown"
                    ///
                    let event = Event(id: id, name: name, desc: desc, url: url, imageUrl: imageUrl, categoryId: categoryId, subCategoryId: subCategoryId, startTime: startTime, endTime: endTime)
                    eventResults.append(name)
                    nearbyEvents.append(event)
                }
            } else {
                print("JSON Error")
            }
        } catch {
            print("Error parsing results \(error.localizedDescription)")
        }
        print("There are \(nearbyEvents.count) events nearby.")
        // Set nearby events to event data
        EventData.sharedData.events = nearbyEvents
        // Load cards
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        loadCardView()
    }
}
