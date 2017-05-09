//
//  Event.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/8/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

class Event {
    var id: Int!
    var name: String!
    var description: String!
    var url: String!
    var imageUrl: String!
    var categoryId: Int!
    var subCategoryId: Int!
    var startTime: String!
    var endTime: String!
    
    init(id: Int, name: String, description: String, url: String, imageUrl: String, categoryId: Int, subCategoryId: Int, startTime: String, endTime: String) {
        // Set all these fields
        setId(id)
        setUrl(url)
        setName(name)
        setEndTime(endTime)
        setImageUrl(imageUrl)
        setStartTime(startTime)
        setCategoryId(categoryId)
        setDescription(description)
        setSubCategoryId(subCategoryId)
    }

    // #MARK: Methods
    
    // Id
    func getId() -> Int {
        return id
    }
    
    func setId(_ _id: Int) {
        id = _id
    }
    
    // Name
    func getName() -> String {
        return name
    }
    
    func setName(_ _name: String) {
        name = _name
    }
    
    // Description
    func getDescription() -> String {
        return description
    }
    
    func setDescription(_ _description: String) {
        description = _description
    }

    // Url
    func getUrl() -> String {
        return url
    }
    
    func setUrl(_ _url: String) {
        url = _url
    }

    // ImageUrl
    func getImageUrl() -> String {
        return imageUrl
    }
    
    func setImageUrl(_ _imageUrl: String) {
        imageUrl = _imageUrl
    }
    
    // CategoryId
    func getCategoryId() -> Int {
        return categoryId
    }
    
    func setCategoryId(_ _categoryId: Int) {
        categoryId = _categoryId
    }

    // Subcategory Id
    func getSubCategoryId() -> Int {
        return subCategoryId
    }
    
    func setSubCategoryId(_ _subcategoryId: Int) {
        subCategoryId = _subcategoryId
    }

    // StartTime
    func getStartTime() -> String {
        return startTime
    }
    
    func setStartTime(_ _startTime: String) {
        startTime = _startTime
    }

    // EndTime
    func getEndTime() -> String {
        return endTime
    }
    
    func setEndTime(_ _endTime: String) {
        endTime = _endTime
    }
}
