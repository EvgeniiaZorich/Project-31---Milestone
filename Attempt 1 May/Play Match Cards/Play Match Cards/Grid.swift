//
//  Grid.swift
//  Play Match Cards
//
//  Created by Евгения Зорич on 01.05.2023.
//

import Foundation

class Grid {
    var numberOfElements: Int
    
    var combinations: [(Int, Int)]
 
    init(numberOfElements: Int, combinations: [(Int, Int)]) {
        self.numberOfElements = numberOfElements
        self.combinations = combinations
    }
}
