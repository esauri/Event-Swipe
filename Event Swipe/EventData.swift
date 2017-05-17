//
//  EventData.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/9/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

class EventData {
    let USER_FILE_NAME = "user.archive"
    let CATEGORIES_FILE_NAME = "categories.archive"
    let SAVED_EVENTS_FILE_NAME = "savedEvents.archive"
    let CITY_KEY = "EventSwipe/EventData/City"
    let EVENTS_FILE_NAME = "events.archive"
    static let sharedData = EventData()
    var events = [Event]()
    var savedEvents = [Event]()
    var categories = [Category]()
    var city: String = "Rochester" {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(city, forKey: CITY_KEY)
        }
    }
    
    // MARK: READ/WRITE DISK
    func addEventsToDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: EVENTS_FILE_NAME)
        _ = NSKeyedArchiver.archiveRootObject(EventData.sharedData.events, toFile: pathToFile.path)
    }
    
    func addSavedEventsToDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        _ = NSKeyedArchiver.archiveRootObject(EventData.sharedData.savedEvents, toFile: pathToFile.path)
    }
    
    func addCategoriesToDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: CATEGORIES_FILE_NAME)
        _ = NSKeyedArchiver.archiveRootObject(EventData.sharedData.categories, toFile: pathToFile.path)
    }

    func loadEventsFromDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: EVENTS_FILE_NAME)
        
        // Reload EventData.sharedData.events array from disk
        EventData.sharedData.events = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [Event]
    }
    
    func loadSavedEventsFromDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        
        // Reload EventData.sharedData.savedEvents array from disk
        EventData.sharedData.savedEvents = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [Event]
    }
    
    func loadCategoriesFromDisk() {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: CATEGORIES_FILE_NAME)
        
        // Reload EventData.sharedData.categories array from disk
        EventData.sharedData.categories = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [Category]
    }
    
    func loadDocumentData() {
        // Paths to file
        let eventsPathToFile = FileManager.filePathInDocumentsDirectory(fileName: EVENTS_FILE_NAME)
        let categoriesPathToFile = FileManager.filePathInDocumentsDirectory(fileName: CATEGORIES_FILE_NAME)
        let savedEventsPathToFile = FileManager.filePathInDocumentsDirectory(fileName: SAVED_EVENTS_FILE_NAME)
        
        if FileManager.default.fileExists(atPath: eventsPathToFile.path) {
            loadEventsFromDisk()
        } else {
            addEventsToDisk()
        }
        
        if FileManager.default.fileExists(atPath: categoriesPathToFile.path) {
            // Load categories
            loadCategoriesFromDisk()
        } else {
            // create categories
            createCategories()
        }

        // Check if file exists
        if FileManager.default.fileExists(atPath: savedEventsPathToFile.path) {
            // Load events
            loadSavedEventsFromDisk()
        } else {
            addSavedEventsToDisk()
        }
    }
    
    func createCategories() {
        categories = [
            Category(id: 105, name: "Arts", imageURL: "arts.jpg"),
            Category(id: 118, name: "Auto, Boat, & Air", imageURL: "auto.jpg"),
            Category(id: 101, name: "Business", imageURL: "business.jpg"),
            Category(id: 111, name: "Causes", imageURL: "charity.jpg"),
            Category(id: 113, name: "Community", imageURL: "community.jpg"),
            Category(id: 115, name: "Education", imageURL: "education.jpg"),
            Category(id: 106, name: "Fashion", imageURL: "fashion.jpg"),
            Category(id: 104, name: "Film & Media", imageURL: "film & media.jpg"),
            Category(id: 110, name: "Food & Drink", imageURL: "food & drink.jpg"),
            Category(id: 112, name: "Government", imageURL: "government.jpg"),
            Category(id: 107, name: "Health", imageURL: "health.jpg"),
            Category(id: 119, name: "Hobbies", imageURL: "hobbies.jpg"),
            Category(id: 116, name: "Holiday", imageURL: "holiday.jpg"),
            Category(id: 117, name: "Lifestyle", imageURL: "lifestyle.jpg"),
            Category(id: 103, name: "Music", imageURL: "music.jpg"),
            Category(id: 102, name: "Science & Tech", imageURL: "science & tech.jpg"),
            Category(id: 114, name: "Spirituality", imageURL: "spirituality.jpg"),
            Category(id: 108, name: "Sports & Fitness", imageURL: "sports & fitness.jpg"),
            Category(id: 109, name: "Travel & Outdoor", imageURL: "travel & outdoor.jpg"),
        ]
        addCategoriesToDisk()
    }
}
