//
//  CardCell.swift
//  Milestone - Day 99 - New attemot
//
//  Created by Евгения Зорич on 27.04.2023.
//

import UIKit

class CardCell: UICollectionViewCell {

    // MARK:- Properties

    var front: UIImageView!
    var back: UIImageView!

    var card: Card?



    // MARK:- Functions

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        build()
    }

    func set(card: Card) {
        self.card = card
        front.image = UIImage(named: card.frontImage)
        back.image = UIImage(named: card.backImage)

        reset(state: card.state)
    }

    func animateFlipTo(state: CardState) {
        guard state == .front || state == .back else { fatalError("Can only flip to front or back") }

        let from: UIView, to: UIView
        let transition: AnimationOptions

        if state == .front {
            guard getFacingSide() == .back else { return }
            from = back
            to = front
            transition = .transitionFlipFromRight
        }
        else {
            guard getFacingSide() == .front else { return }
            from = front
            to = back
            transition = .transitionFlipFromLeft
        }

        UIView.transition(from: from, to: to, duration: 0, options: [transition, .showHideTransitionViews])
    }

    func animateMatch() {
        transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }

    func animateCompleteGame() {
        transform = CGAffineTransform(scaleX: 1, y: 1)
    }

    func updateAfterRotateOrResize() {
        DispatchQueue.main.async { [weak self] in
            self?.updateImagesSize()
        }

        if card?.state == .matched {
            // aync allows scale animation to continue if in progress
            DispatchQueue.main.async { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
        }
    }

    // MARK:- Private functions

    fileprivate func build() {
        let size = frame.size

        front = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        front.contentMode = .scaleAspectFit
        front.isHidden = true

        back = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        back.contentMode = .scaleAspectFit

        addSubview(front)
        addSubview(back)
    }

    fileprivate func reset(state: CardState) {
        // cells are reused by the collection view, make sure to clean everything
        cancelAnimations()

        var flipTarget: CardState
        var scaleFactor: CGFloat

        updateImagesSize()

        // reset card position
        switch state {
        case .back:
            flipTarget = .back
            scaleFactor = 1
        case .front:
            flipTarget = .front
            scaleFactor = 1
        case .matched:
            flipTarget = .front
            scaleFactor = 0.6
        case .complete:
            flipTarget = .front
            scaleFactor = 1
        }

        animateFlipTo(state: flipTarget)
        DispatchQueue.main.async { [weak self] in
            self?.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }

    fileprivate func updateImagesSize() {
        let size = frame.size

        front.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        back.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    fileprivate func cancelAnimations() {
        layer.removeAllAnimations()
        front.layer.removeAllAnimations()
        back.layer.removeAllAnimations()
    }

    fileprivate func getFacingSide() -> CardState {
        if back.isHidden {
            return .front
        }

        return .back
    }
}
