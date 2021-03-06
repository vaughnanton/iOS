//
//  Card.swift
//  Concentration
//
//  Created by Vahag Antonyan on 1/8/19.
//  Copyright © 2019 Vahagn Antonyan. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
        { didSet { if isFaceUp { hasBeenSeen = true } } }
    var isMatched = false
    var hasBeenSeen = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
