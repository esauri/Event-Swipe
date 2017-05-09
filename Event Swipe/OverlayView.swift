//
//  OverlayView.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/1/17.
//  Adapted from cwRichardKim's TinderSimpleSwipeCards
//  Github: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//  Article: https://medium.com/@cwRichardKim/adding-tinder-esque-cards-to-your-iphone-app-4047967303d1#.m2w4za62z
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum OverlayViewMode {
    case None
    case Left
    case Right
}

class OverlayView: UIView {
    // MARK: Variables
    var imageView = UIImageView()
    var responseLabel = UITextView()
    
    var mode = OverlayViewMode.None
    var eventName: String = "Unknown Event"

    // MARK: Initializer
    
    /*
     * init - OverlayView initializer
     * param {CGRect} frame - view frame
     */
    override init (frame: CGRect) {
        super.init(frame: frame)
        setView()
        addImageView()
        addResponseLabel()
    }
    
    /*
     * init - OverlayView convenient initializer
     * param {CGRect} frame - view frame
     * param {String} events
     */
    convenience init(frame: CGRect, event: Event) {
        self.init(frame: frame)
        
        setEvent(event: event)
        setView()
        addImageView()
        addResponseLabel()
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Methods
    
    /*
     * setView - sets up view style
     */
    func setView () {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.clear
    }
    
    /*
     * addImageView - adds the card center image (Trump face)
     */
    func addImageView () {
        setImageViewFrame()
        self.addSubview(imageView)
    }
    
    /*
     * setImageViewFrame - sets the card center image (Trump face)
     */
    func setImageViewFrame () {
        let imageWidth: CGFloat = 150
        let imageHeight = imageWidth
        let imageX = (self.frame.width / 2) - (imageWidth / 2)
        let imageY = (self.frame.height / 2) - (imageHeight / 2)
        
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }
    
    /*
     * setMyImageView - sets image
     * param {String} _image - image string name
     */
    func setMyImageView (_ _image: String) {
        imageView.image = UIImage(named: _image)
    }
    
    /*
     * addResponseLabel - adds the answer label
     */
    func addResponseLabel () {
        setResponseLabelFrame()
        self.addSubview(responseLabel)
    }
    
    /*
     * setResponseLabelFrame - sets the answer label frame
     */
    func setResponseLabelFrame () {
        let labelX: CGFloat = 30
        let labelY: CGFloat = 10
        let labelWidth: CGFloat = self.frame.width - ( labelX * 2)
        let labelHeight: CGFloat = self.frame.height / 4
        
        responseLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        
        responseLabel.textAlignment = .center
        responseLabel.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 10)
        responseLabel.isEditable = false
        responseLabel.font = .systemFont(ofSize: 20)
        responseLabel.backgroundColor = UIColor.clear
        setResponseLabelText(eventName: eventName)

    }
    
    /*
     * setResponseLabelText - sets the answer label text
     * param {String} _response - choice response
     */
    func setResponseLabelText (eventName: String) {
        responseLabel.text = eventName
    }

    /*
     * setMode - sets the OverlayView's mode
     * param {OverlayViewMode} _mode - view mode
     */
    func setMode (_ _mode: OverlayViewMode) {
        
        // If mode is the same
        if self.mode == _mode {
            // Return
            return
        }
        
        // Otherwise
        // Set new mode
        self.mode = _mode
        
        // Check mode
        switch _mode {
        // If left mode
        case .Left:
//            setMyImageView(face!)
            break
        // If left mode
        case .Right:
//            setMyImageView(face!)
            break
        // Otherwise
        case .None:
            // Set face to default
//            let face = trumpFaces["none"]
//            let response = ""
//            
//            setResponseLabelText(response)
//            setMyImageView(face!)
            break
        }
    }
    
    /*
     * setEvent - sets the OverlayView's event
     * param {String} event
     */
    func setEvent (event: Event) {
        self.eventName = event.name
    }
}
