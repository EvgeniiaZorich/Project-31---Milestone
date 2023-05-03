//
//  ViewController.swift
//  Milestone - Day 99 - New attemot
//
//  Created by Евгения Зорич on 27.04.2023.
//

import UIKit

class GameViewController: UICollectionViewController {
    var cards = [Card]()
    var flippedCards = [(position: Int, card: Card)]()
    
    var backImageSize: CGSize!
    var cardSize: CardSize!
    
    var currentGrid = 4
    var currentGridElement = 1
    
    let cardsDirectory = "Cards.bundle/"
    var currentCards = "Characters"

    var currentCardSizeValid = false
    var currentCardSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Match Pairs"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(newGame))

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))

        let (gridSide1, gridSide2) = grids[currentGrid].combinations[currentGridElement]
//        // loading default values, they will be overriden later
        cardSize = CardSize(imageSize: CGSize(width: 50, height: 50), gridSide1: gridSide1, gridSide2: gridSide2)
        
        newGame()
    }

    @objc func newGame() {
        let (gridSide1, gridSide2) = grids[currentGrid].combinations[currentGridElement]

        guard (gridSide1 * gridSide2) % 2 == 0 else {
            fatalError("Odd number of cards")
        }
        
        cardSize.gridSide1 = gridSide1
        cardSize.gridSide2 = gridSide2

        cards = [Card]()
//        resetFlippedCards()
//        cancelAnimators()
        
//        loadCards()

        currentCardSizeValid = false
        collectionView.reloadData()
    }
    
    func loadCards() {
        var backImage: String? = nil
        var frontImages = [String]()

        let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: cardsDirectory + currentCards)!
        
        for url in urls {
            // convention: unique names to avoid caching issue
            // and starting with 1 for sorting
            if url.lastPathComponent.starts(with: "1\(currentCards)_back.") {
                backImage = url.path
            }
            else {
                frontImages.append(url.path)
            }
        }
        
        // get image size
        guard backImage != nil else { fatalError("No back image found") }
        guard let size = UIImage(named: backImage!)?.size else { fatalError("Cannot get image size") }
        cardSize.imageSize = size

        let (gridSide1, gridSide2) = grids[currentGrid].combinations[currentGridElement]
        let cardsNumber = gridSide1 * gridSide2
        
        // more images than required grid
        while frontImages.count > cardsNumber / 2 {
            frontImages.remove(at: Int.random(in: 0..<frontImages.count))
        }
        // not enough images to fill grid
        while frontImages.count < cardsNumber / 2 {
            frontImages.append(frontImages[Int.random(in: 0..<frontImages.count)])
        }
        
        // duplicate all images to make pairs
        frontImages += frontImages
        // shuffle images
        frontImages.shuffle()

        for i in 0..<cardsNumber {
            cards.append(Card(frontImage: frontImages[i], backImage: backImage!))
        }
    }
}


extension GameViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        guard let cell = dequeuedCell as? CardCell else { return dequeuedCell }

        cell.set(card: cards[indexPath.row])

        return cell
    }
}
