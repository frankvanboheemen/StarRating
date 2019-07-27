//
//  RatingControl.swift
//  StarRating
//
//  Created by Frank van Boheemen on 15/07/2019.
//  Copyright © 2019 Frank van Boheemen. All rights reserved.
//

import Cocoa

protocol RatingControlDelegate {
    func ratingUpdated(rating: Int)
}

@IBDesignable class RatingControl: NSStackView, RatingButtonDelegate {
    @IBInspectable var starSize: CGSize = CGSize(width: 40.0, height: 40.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    private var ratingButtons = [RatingButton]()
    var rating = 0
    var ratingDelegate: RatingControlDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupButtons()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupButtons()
    }
    
    private func setupButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for i in 0..<starCount {
            let button = RatingButton(title: "", target: self, action: #selector(RatingControl.ratingButtonPressed))
            button.ratingButtonDelegate = self
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            addArrangedSubview(button)
            
            if let image = NSImage(named: "solid-star") {
                button.set(image: image)
            }
            button.setAccessibilityIdentifier("RatingButton-\(i)")
            ratingButtons.append(button)
        }
    }
    
    override func layout() {
        super.layout()
        let area = NSTrackingArea.init(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
    
    func set(rating: Int) {
        self.rating = rating
        show(rating: rating)
    }
    
    private func show(rating: Int) {
        for i in 0..<rating {
            ratingButtons[i].state = .on
        }
        
        for i in rating..<ratingButtons.count {
            ratingButtons[i].state = .off
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        for button in ratingButtons {
            button.highlight(false)
        }
    }
    
    @objc func ratingButtonPressed(button: RatingButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        show(rating: rating)
        ratingDelegate?.ratingUpdated(rating: rating)
    }
    
    //MARK: - RatingButtonDelegate
    func hovering(_ button: RatingButton, _ isOn: Bool) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        for i in 0..<(index + 1) {
            ratingButtons[i].highlight(true)
        }
        
        for i in (index + 1)..<ratingButtons.count {
            ratingButtons[i].highlight(false)
        }
    }
    
    //Used in UI-tests
    override func accessibilityIdentifier() -> String {
        return "RatingControl"
    }
    
    override func isAccessibilityElement() -> Bool {
        return true
    }
}
