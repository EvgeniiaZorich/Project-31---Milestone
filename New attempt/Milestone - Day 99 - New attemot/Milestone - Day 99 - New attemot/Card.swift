//
//  Card.swift
//  Milestone - Day 99 - New attemot
//
//  Created by Евгения Зорич on 27.04.2023.
//

import Foundation

enum CardState {
    case front
    case back
    case matched
    case complete
}

class Card {
    var state: CardState = .back
    
    var backImage: String
    var frontImage: String
    
    init(frontImage: String, backImage: String) {
        self.frontImage = frontImage
        self.backImage = backImage
    }
}
