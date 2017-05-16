//
//  Category.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/15/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

class Category: NSObject, NSCoding {
    var id: Int!
    var name: String!
    var imageURL: String!
    
    enum CATEGORY_KEY: String {
        case ID = "EVENT_SWIPE/CATEGORY/ID",
            NAME = "EVENT_SWIPE/CATEGORY/NAME",
            IMAGE_URL = "EVENT_SWIPE/CATEGORY/IMAGE_URL"
    }

    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: CATEGORY_KEY.ID.rawValue) as! Int
        name = aDecoder.decodeObject(forKey: CATEGORY_KEY.NAME.rawValue) as! String
        imageURL = aDecoder.decodeObject(forKey: CATEGORY_KEY.IMAGE_URL.rawValue) as! String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CATEGORY_KEY.ID.rawValue)
        aCoder.encode(name, forKey: CATEGORY_KEY.NAME.rawValue)
        aCoder.encode(imageURL, forKey: CATEGORY_KEY.IMAGE_URL.rawValue)
    }
}
