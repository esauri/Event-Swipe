//
//  CardView.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/1/17.
//  In part, adapted from cwRichardKim's TinderSimpleSwipeCards
//  Github: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//  Article: https://medium.com/@cwRichardKim/adding-tinder-esque-cards-to-your-iphone-app-4047967303d1#.m2w4za62z
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import UIKit

class CardView: UIView, DraggableViewDelegate {
    // MARK: Variables
    
    // Card constants
    let MAX_CARDS_LOADED = 3
    var maximumNumberOfCards = 0
    let CARD_HEIGHT = CGFloat(380)
    let CARD_WIDTH = CGFloat(300)
    
    // UI constants
    var MARGIN = CGFloat(20)
    var BAR_HEIGHT = CGFloat(100)
    var BAR_HEIGHT_LARGE = CGFloat(100)
    var CARD_MARGIN_TOP = CGFloat(0)
    var CARD_MARGIN_LEFT = CGFloat(0)
    
    // UI constants
    let exitButton = UIButton()
    let messageButton = UIButton()
    let saveButton = UIButton()
    let dismissButton = UIButton()
    
    // UI Element constants
    let backgroundImage = UIImageView()
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    
    // Card information
    var loadedCards: [DraggableView] = []
    var allCards: [DraggableView] = []
    var cardsLoadedIndex = 0
    var numLoadedCardsCap = 0
    
    // Hold our events
    var events = [String]()

    // MARK: Intitializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * init - CardView initializer
     * param {CGRect} frame - view frame
     */
    override init (frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        
        // Calculate sizes for "responsiveness"
        calculateSizes(frame)
    }
    
    
    // MARK: Setup Methods
    /*
     * calculateSizes - calculates the size of elements based on phone
     * param {CGRect} frame - view frame
     */
    func calculateSizes (_ _frame: CGRect) {
        let topMargin = getStatusBarHeight()
        
        BAR_HEIGHT_LARGE = (_frame.size.height / 12) + topMargin
        
        if BAR_HEIGHT_LARGE > 100 {
            BAR_HEIGHT_LARGE = 100
        }
        
        BAR_HEIGHT = BAR_HEIGHT_LARGE - (BAR_HEIGHT_LARGE / 3)
        
        MARGIN = ((_frame.size.width - CARD_WIDTH) / 2) - 10
        
        if MARGIN < 10 {
            MARGIN = 10
        }
        
        CARD_MARGIN_TOP = 100
        CARD_MARGIN_LEFT = (_frame.size.width - CARD_WIDTH) / 2
    }

   /*
    * setupView - calls functions to setup the view
    */
    func setupView () {
        self.backgroundColor = UIColor.clear
        addTopLabel()
        addBottomLabel()
        addDismissButton()
        addSaveButton()
    }
    
    func loadView() {
        setupView()
        setMaxiumumNumberOfCards(MAX_CARDS_LOADED)
        setLoadedCardsCap()
        createCards()
        displayCards()
        displayCurrentCard()
    }

    /*
     * addTopLabel - adds top label to the view
     */
    func addTopLabel () {
        let topMargin = BAR_HEIGHT + BAR_HEIGHT_LARGE
        let maxHeight = ((self.frame.size.height - CARD_HEIGHT) / 2) - topMargin + BAR_HEIGHT_LARGE
        
        topLabel.frame = CGRect(x: MARGIN, y: topMargin, width: self.frame.width - (MARGIN * 2), height: maxHeight)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        topLabel.textColor = UIColor.black
        addSubview(topLabel)
    }
    
    /*
     * setTopLabelText - sets top label text
     * param {String} text
     */
    func setTopLabelText (_ text: String) {
        self.topLabel.text = text
    }
    
    /*
     * addBottomLabel - adds category label to the view
     */
    func addBottomLabel () {
        let topMargin = CARD_MARGIN_TOP + CARD_HEIGHT + BAR_HEIGHT_LARGE
        let maxHeight = self.frame.size.height - topMargin
        
        bottomLabel.frame = CGRect(x: MARGIN, y: topMargin, width: self.frame.width - (MARGIN * 2), height: maxHeight)
        bottomLabel.textAlignment = .center
        bottomLabel.numberOfLines = 1
        bottomLabel.textColor = UIColor.black
        addSubview(bottomLabel)
    }
    
    /*
     * setBottomLabelText - sets bottom label text
     * param {String} text
     */
    func setBottomLabelText (_ text: String) {
        self.bottomLabel.text = text
    }
    
    /*
     * addDismissButton - adds X button to the view
     */
    func addDismissButton () {
        let btnX = MARGIN * 2
        let btnY = CARD_MARGIN_TOP + BAR_HEIGHT_LARGE + CARD_HEIGHT + 10
        
        dismissButton.frame = CGRect(x: btnX, y: btnY, width: BAR_HEIGHT, height: BAR_HEIGHT)
        dismissButton.setImage(UIImage(named: "dismissButton"), for: .normal)
        dismissButton.addTarget(self, action: #selector(CardView.swipeLeft), for: .touchUpInside)
        addSubview(dismissButton)
    }
    
    /*
     * addSaveButton - adds check button to the view
     */
    func addSaveButton () {
        let btnX = self.frame.width - BAR_HEIGHT - ( MARGIN * 2 )
        let btnY = CARD_MARGIN_TOP + BAR_HEIGHT_LARGE + CARD_HEIGHT + 10
        
        saveButton.frame = CGRect(x: btnX, y: btnY, width: BAR_HEIGHT, height: BAR_HEIGHT)
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveButton.addTarget(self, action: #selector(CardView.swipeRight), for: .touchUpInside)
        addSubview(saveButton)
    }
    
    // MARK: Card Helpers

    /*
     * getMaxiumumNumberOfCards - returns the max number of cards
     * return {Int} maximumNumberOfCards - maximum number of cards
     */
    func getMaxiumumNumberOfCards () -> Int {
        return maximumNumberOfCards
    }
    
    /*
     * setMaxiumumNumberOfCards - sets the max number of cards
     * param {Int} _value - maximum number of cards
     */
    func setMaxiumumNumberOfCards (_ _value: Int) {
        maximumNumberOfCards = _value
    }
    
    /*
     * setLoadedCardsCap - sets the max number of cards we can load
     */
    func setLoadedCardsCap () {
        numLoadedCardsCap = 0
        
        if events.count > maximumNumberOfCards {
            numLoadedCardsCap = maximumNumberOfCards
        }
        else {
            numLoadedCardsCap = events.count
        }
    }
    
    /*
     * stillCardsToLoad - returns if we still have cards to load
     * return {Bool}
     */
    func stillCardsToLoad () -> Bool {
        return events.count > 0
    }
    
    /*
     * moreCardsToLoad - returns if we still have cards to load
     * return {Bool}
     */
    func moreCardsToLoad () -> Bool {
        return cardsLoadedIndex < allCards.count
    }
    
    /*
     * stillCardsToShow - returns if we still have cards to display
     * return {Bool}
     */
    func stillCardsToShow () -> Bool {
        return loadedCards.count > 0
    }
    
    // MARK: Card Creation
    /*
     * createCards - creates cards
     */
    func createCards () {
        if events.count > 0 {
            
            let cardFrame = CGRect(x: CARD_MARGIN_LEFT, y: CARD_MARGIN_TOP + BAR_HEIGHT_LARGE, width: CARD_WIDTH, height: CARD_HEIGHT)
            
            for _ in 0..<events.count {
                let newCard = DraggableView(frame: cardFrame)
                newCard.delegate = self
                allCards.append(newCard)
            }
        }
    }
    
    /*
     * displayCards - displays cards
     */
    func displayCards () {
        for i in 0..<numLoadedCardsCap {
            loadCardAt(i)
        }
    }
    
    /*
     * loadNextCard - loads next card
     */
    func loadNextCard () {
        loadCardAt(cardsLoadedIndex)
    }
    
    /*
     * loadCardAt - loads card
     * param {Int} _index - index of card to load
     */
    func loadCardAt (_ _index: Int) {
        let currentCard = allCards[_index]
        
        loadedCards.append(currentCard)
        
        if loadedCards.count > 1 {
            let previousCard = loadedCards.count - 1
            let antecedentPreviousCard = loadedCards.count - 2
            
            insertSubview(loadedCards[previousCard], belowSubview: loadedCards[antecedentPreviousCard])
        }
            
        else {
            addSubview(loadedCards[0])
        }
        
        cardsLoadedIndex += 1
    }
    
    /*
     * #MARK: Current Card
     * Current Card
     */
    
    /*
     * displayCurrentCard - displays current card
     */
    func displayCurrentCard () {
        let currentCard = loadedCards[0]
        let event = events[0]
        
        currentCard.loadView(event: event)
    }
    
    /*
     * #MARK: Swipe Interaction
     * Swipe Interactions
     */

    /*
     * swipeLeft - swipes a card left
     */
    func swipeLeft () {
        if loadedCards.count > 0 {
            let dragView = loadedCards[0]
            
            dragView.leftClickAction()
        }
    }
    
    /*
     * swipeRight - swipes a card right
     */
    func swipeRight () {
        if loadedCards.count > 0 {
            let dragView = loadedCards[0]
            
            dragView.rightClickAction()
        }
    }
    
    /*
     * processCardSwipe - process for when a card has been swiped
     * param {String} _direction - direction a card was swiped in
     */
    func processCardSwipe (_ _direction: String) {
        switch _direction {
        case "left":
            userSwipedLeft()
        case "right":
            userSwipedRight()
        default:
            break
        }
        
        afterCardSwipe()
    }
    
    /*
     * afterCardSwipe - process for when a card has been swiped
     */
    func afterCardSwipe () {
        // Remove current card and event
        loadedCards.remove(at: 0)
        events.remove(at: 0)
        
        // If we still have cards to show
        if stillCardsToShow() {
            // Display them
            displayCurrentCard()
        }
            // Otherwise
        else {
            // No cards to show
            setTopLabelText("No more events to show!")
        }
        
        if moreCardsToLoad() {
            loadNextCard()
        }
    }
    
    /*
     * cardSwipedLeft - processes the left swipe
     * param {DraggableView} _card - card
     */
    func cardSwipedLeft (_ _card: DraggableView) {
        // Process card swipe
        processCardSwipe("left")
    }
    
    /*
     * cardSwipedRight - processes the right swipe
     * param {DraggableView} _card - card
     */
    func cardSwipedRight (_ _card: DraggableView) {
        processCardSwipe("right")
    }
    
    /*
     * userSwipedLeft - method for when player swipes left
     */
    func userSwipedLeft () {
        setBottomLabelText("Dismissed Event!")
    }
    
    /*
     * userSwipedRight - method for when player swipes right
     */
    func userSwipedRight () {
        setBottomLabelText("Saved Event!")
    }
    
    /*
     * getStatusBarHeight - gets the height of the status bar
     * return {CGFloat} - status bar height
     */
    func getStatusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
}
