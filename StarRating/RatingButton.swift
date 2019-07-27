//
//  RatingButton.swift
//  StarRating
//
//  Created by Frank van Boheemen on 15/07/2019.
//  Copyright © 2019 Frank van Boheemen. All rights reserved.
//

import Cocoa

protocol RatingButtonDelegate {
    func hovering(_ button: RatingButton, _ isOn: Bool)
}

class RatingButton: NSButton {    
    var ratingButtonDelegate: RatingButtonDelegate?

    var defaultColor = NSColor.lightGray
    var selectedColor = NSColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
    override var state: NSControl.StateValue {
        didSet {
            image = (self.state == .on) ? image?.tint(color: selectedColor) : image?.tint(color: defaultColor)
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        layer?.backgroundColor = NSColor.clear.cgColor
        isBordered = false
        imageScaling = .scaleProportionallyUpOrDown
        imagePosition = .imageOnly
    }
    
    override func layout() {
        super.layout()
        let area = NSTrackingArea.init(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
    
    func set(image: NSImage) {
        self.image = image.tint(color: defaultColor)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        ratingButtonDelegate?.hovering(self, true)
    }

    override func mouseExited(with event: NSEvent) {
        //This is implemented to stop the stars from blinking when the user hovers from one to the other
    }
}
