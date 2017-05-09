//
//  Event.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/8/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    var id: Int!
    var name: String!
    var desc: String!
    var url: String!
    var imageUrl: String!
    var categoryId: Int!
    var subCategoryId: Int!
    var startTime: String!
    var endTime: String!

    enum EVENT_KEY: String {
        case ID = "EVENT_SWIPE/EVENT/ID_KEY",
            NAME = "EVENT_SWIPE/EVENT/NAME_KEY",
            desc = "EVENT_SWIPE/EVENT/desc_KEY",
            URL = "EVENT_SWIPE/EVENT/URL_KEY",
            IMAGE_URL = "EVENT_SWIPE/EVENT/IMAGE_URL_KEY",
            CATEGORY_ID = "EVENT_SWIPE/EVENT/CATEGORY_ID_KEY",
            SUB_CATEGORY_ID = "EVENT_SWIPE/EVENT/SUB_CATEGORY_ID_KEY",
            START_TIME = "EVENT_SWIPE/EVENT/START_TIME_KEY",
            END_TIME = "EVENT_SWIPE/EVENT/END_TIME_KEY"
    }

    init(id: Int, name: String, desc: String, url: String, imageUrl: String, categoryId: Int, subCategoryId: Int, startTime: String, endTime: String) {
        // Set all these fields
        self.id = id
        self.url = url
        self.name = name
        self.endTime = endTime
        self.imageUrl = imageUrl
        self.startTime = startTime
        self.categoryId = categoryId
        self.desc = desc
        self.subCategoryId = subCategoryId
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Decode id
        id = aDecoder.decodeObject(forKey: EVENT_KEY.ID.rawValue) as! Int
        
        // Decode url
        url = aDecoder.decodeObject(forKey: EVENT_KEY.URL.rawValue) as! String
        
        // Decode name
        name = aDecoder.decodeObject(forKey: EVENT_KEY.NAME.rawValue) as! String
        
        // Decode endTime
        endTime = aDecoder.decodeObject(forKey: EVENT_KEY.END_TIME.rawValue) as! String
        
        // Decode imageUrl
        imageUrl = aDecoder.decodeObject(forKey: EVENT_KEY.IMAGE_URL.rawValue) as! String
        
        // Decode startTime
        startTime = aDecoder.decodeObject(forKey: EVENT_KEY.START_TIME.rawValue) as! String
        
        // Dencode categoryId
        categoryId = aDecoder.decodeObject(forKey: EVENT_KEY.CATEGORY_ID.rawValue) as! Int
        
        // Decode desc
        desc = aDecoder.decodeObject(forKey: EVENT_KEY.desc.rawValue) as! String
        
        // Decode subCategoryId
        subCategoryId = aDecoder.decodeObject(forKey: EVENT_KEY.SUB_CATEGORY_ID.rawValue) as! Int
    }
    
    public func encode(with aCoder: NSCoder) {
        // Encode id
        aCoder.encode(id, forKey: EVENT_KEY.ID.rawValue)
        
        // Encode url
        aCoder.encode(url, forKey: EVENT_KEY.URL.rawValue)
        
        // Encode name
        aCoder.encode(name, forKey: EVENT_KEY.NAME.rawValue)
        
        // Encode endTime
        aCoder.encode(endTime, forKey: EVENT_KEY.END_TIME.rawValue)
        
        // Encode imageUrl
        aCoder.encode(imageUrl, forKey: EVENT_KEY.IMAGE_URL.rawValue)
        
        // Encode startTime
        aCoder.encode(startTime, forKey: EVENT_KEY.START_TIME.rawValue)
        
        // Encode categoryId
        aCoder.encode(categoryId, forKey: EVENT_KEY.CATEGORY_ID.rawValue)
        
        // Encode desc
        aCoder.encode(desc, forKey: EVENT_KEY.desc.rawValue)
        
        // Encode subCategoryId
        aCoder.encode(subCategoryId, forKey: EVENT_KEY.SUB_CATEGORY_ID.rawValue)
        
    }
}
