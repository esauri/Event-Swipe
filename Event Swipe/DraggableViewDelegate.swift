//
//  DraggableViewDelegate.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/1/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import Foundation

protocol DraggableViewDelegate {
    func cardSwipedLeft(_ _card: DraggableView)
    func cardSwipedRight(_ _card: DraggableView)
}
