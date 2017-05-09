//
//  EventData.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/9/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

class EventData {
    let SAVED_EVENTS_FILE_NAME = "savedEvents.archive"
    static let sharedData = EventData()
    var events = [Event]()
    var savedEvents = [Event]()
    
    // MARK: READ/WRITE DISK
    func addSavedEventsToDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        _ = NSKeyedArchiver.archiveRootObject(EventData.sharedData.savedEvents, toFile: pathToFile.path)
    }
    
    func loadSavedEventsFromDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        
        // Reload EventData.sharedData.savedEvents array from disk
        EventData.sharedData.savedEvents = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [Event]
    }
    
    func loadDocumentData() {
        // Path to file
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        
        // Check if file exists
        if FileManager.default.fileExists(atPath: pathToFile.path) {
            // Load parks
            loadSavedEventsFromDisk()
        } else {
            addSavedEventsToDisk()
        }
    }
}
