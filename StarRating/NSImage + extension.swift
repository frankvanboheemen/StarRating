//
//  NSImage + extension.swift
//  StarRating
//
//  Created by Frank van Boheemen on 15/07/2019.
//  Copyright © 2019 Frank van Boheemen. All rights reserved.
//

import Cocoa

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        
        return image
    }
}
