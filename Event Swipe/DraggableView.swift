//
//  DraggableView.swift
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

// Card Physics Constants
let ACTION_MARGIN = CGFloat(120)
let SCALE_STRENGTH = CGFloat(4)
let SCALE_MAX = CGFloat(0.93)
let ROTATION_MAX = CGFloat(1)
let ROTATION_STRENGTH = CGFloat(320)
let ROTATION_ANGLE = CGFloat(Double.pi/8)

class DraggableView: UIView {
    // MARK: Variables
    var delegate: DraggableViewDelegate?
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    // Coordinate vars
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var originalPoint = CGPoint()
    
    // Background image
    var backgroundImage = UIImageView()
    
    // UI gesture recognizer
    var panGestureRecognizer = UIGestureRecognizer()
    
    // Overlay view
    var overlayView: OverlayView?
    var cardImage: UIImage?
    
    var event: Event!

    // MARK: Initializer
    
    /*
     * init - DraggableView initializer
     * @param {CGRect} frame - view frame
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup our Draggable View
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been impemented")
    }

    // MARK: Setup & Display Methods
    
    /*
     * loadView - loads DraggableView
     * @param {String} event
     */
    func loadView(event: Event) {
        let marginLeft: CGFloat = 5
        let marginTop: CGFloat = 10
        let imageWidth: CGFloat = self.frame.size.width - marginLeft * 2
        let imageHeight: CGFloat = self.frame.size.height - marginTop * 2
        self.event = event
        
        if let url = URL(string: (event.imageUrl)!) {
            let data = try? Data(contentsOf: url)
            cardImage = UIImage(data: data!)
            backgroundImage.frame = CGRect(x: marginLeft, y: marginTop, width: imageWidth, height: imageHeight)
            // Change image based on event image
            backgroundImage.image = cardImage
            backgroundImage.contentMode = UIViewContentMode.scaleAspectFit
            self.addSubview(backgroundImage)
        }

        // Add an overlay view
        addOverlayView(event: event)
        
        // add the gesture recognizer
        addGestureRecognizer()
    }

    /*
     * setupView - sets DraggableView layout
     */
    func setupView() {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.backgroundColor = UIColor.white

    }
    
    /*
     * addOverlayView - sets and adds the OverlayView
     * @param {String} events
     */
    func addOverlayView(event: Event) {
        // Create an overlay view frame
        let overlayViewFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        // Set the overlay view
        overlayView = OverlayView(frame: overlayViewFrame, event: event)
        
        // Add overlay view
        addSubview(overlayView!)
    }
    
    /*
     * updateOverlay - updates overlay mode
     * param {CGFloat} _distance - card distance
     */
    func updateOverlay(_ _distance: CGFloat) {
        // If distance is greater than 0
        if _distance > 0 {
            // Set mode to right
            overlayView?.setMode(.Right)
        }
            // Else set mode to left
        else {
            overlayView?.setMode(.Left)
        }
        // Change card alpha for transition effect
        overlayView?.alpha = min(fabs(_distance) / 100, 1)
    }

    // MARK: Interation Methods

    /*
     * addGestureRecognizer - sets and adds the UIPanGestureRecognizer
     */
    func addGestureRecognizer() {
        // Set panGestureRecognizer to being dragged when there is an action on the dragabble view
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        
        // Add gestureRecognizer to the view
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    /*
     * beingDragged - transforms card when being drapped
     * @param {UIPanGestureRecognizer} gestureRecognizer
     */
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        // Get the x and y coordinates for center
        xFromCenter = gestureRecognizer.translation(in: self).x
        yFromCenter = gestureRecognizer.translation(in: self).y
        
        // Check the gesture state
        switch gestureRecognizer.state {
        // If state is began, set the original point to the card center
        case .began:
            self.originalPoint = self.center
            break
        // If state is changed
        case .changed:
            // Get the rotation force
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            
            // Get the rotation angle
            let rotationAngle = (ROTATION_ANGLE * rotationStrength)
            
            // Scale the card
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            // Change the card's center
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            
            // Get the transform
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            // Get the scale
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            
            // Transform the card
            self.transform = scaleTransform
            
            // Update overlayView
            self.updateOverlay(xFromCenter)
            
            break
        case .ended:
            // When state is ended call afterSwipeAction
            afterSwipeAction()
            break
        default:
            break
        }
    }
    
    // MARK: Action Methods

    /*
     * afterSwipeAction - checks the new center of the card
     * and determines where the card should be animated to
     */
    func afterSwipeAction() {
        // If xFromCenter is enough to swipe card out of right view
        if xFromCenter > ACTION_MARGIN {
            // Swipe if right
            rightAction()
        }
            // If xFromCenter is enough to swipe card out of left view
        else if xFromCenter < (-ACTION_MARGIN) {
            // Swipe it left
            leftAction()
        }
            // Otherwise
        else {
            // Animate card back to center
            animateCardBack()
        }
    }
   
    /*
     * leftAction - tells delegate to swipe card to the left
     * we are not animating to the left because of the Trump-o-meter mechanic
     */
    func leftAction () {
        animateCardToTheLeft()

        // Swipe left
        delegate?.cardSwipedLeft(self)
    }
    
   /*
    * rightAction - calls functions to animate card to the right
    * and tells delegate to swipe card to the right
    */
    func rightAction () {
        // Animates card to the right
        animateCardToTheRight()

        // Swipe card right
        delegate?.cardSwipedRight(self)
    }
    
    /*
     * leftClickAction - action for when the left button is pressed
     */
    func leftClickAction() {
        // Set mode to left
        overlayView?.setMode(.Left)
        
        // call leftAction
        leftAction()
    }

    /*
     * rightClickAction - action for when the right button is pressed
     */
    func rightClickAction() {
        // Set mode to right
        overlayView?.setMode(.Right)
        
        // Call rightAction
        rightAction()
    }
    
    // MARK: Animate Methods

    /*
     * animateCardToTheLeft - animates card to the left
     */
    func animateCardToTheLeft() {
        // Get the leftEdge
        let leftEdge = CGFloat(-500)
        
        // Animate card to leftEdge
        animateCardTo(leftEdge)
    }
    
    /*
     * animateCardToTheRight - animates card to the right
     */
    func animateCardToTheRight() {
        // Get the rightEdge
        let rightEdge = CGFloat(500)
        
        // Animate card to rightEdge
        animateCardTo(rightEdge)
    }
    
    /*
     * animateCardTo - animates card to an _edge
     * param {CGFloat} _edge - x point to animate card to
     */
    func animateCardTo(_ _edge: CGFloat) {
        // Get the finishing point of the card
        let finishPoint = CGPoint(x: _edge, y: 2 * yFromCenter + self.originalPoint.y)
        
        // Animate card for 3ms, from center to finishPoint and once animation is done
        // Remove card from view
        UIView.animate(withDuration: 0.3,
                       animations: { self.center = finishPoint },
                       completion: { (value: Bool) in self.removeFromSuperview() })
    }
    
    /*
     * animateCardBack - animates card back to center
     */
    func animateCardBack() {
        // Animate card for 3ms, to original center
        // Reset overlayView
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.center = self.originalPoint
                        self.transform = CGAffineTransform(rotationAngle: 0)
                        self.overlayView?.alpha = 1
                        self.overlayView?.setMode(.None)
        })
    }
}
