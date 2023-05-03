//
//  CardSize.swift
//  Milestone - Day 99 - New attemot
//
//  Created by Евгения Зорич on 27.04.2023.
//

import UIKit

class CardSize {
    var imageSize: CGSize
    var gridSide1: Int
    var gridSide2: Int
    
    init(imageSize: CGSize, gridSide1: Int, gridSide2: Int) {
        self.imageSize = imageSize
        self.gridSide1 = gridSide1
        self.gridSide2 = gridSide2
    }
    
    func getCardSize(collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        
        return CGSize(width: width, height: height)
    }
}
