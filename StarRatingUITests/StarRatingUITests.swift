//
//  StarRatingUITests.swift
//  StarRatingUITests
//
//  Created by Frank van Boheemen on 15/07/2019.
//  Copyright © 2019 Frank van Boheemen. All rights reserved.
//

import XCTest
@testable import StarRating

class StarRatingUITests: XCTestCase {
    var app : XCUIApplication?
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app?.launchArguments.append("--uitesting")
        
        app?.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetThreeStarRating() {
        XCTAssertTrue(isDisplayingRatingControl)
        guard let control = app?.otherElements["RatingControl"] as? RatingControl else { return }
        
        let identifier = "RatingButton-2"
        XCTAssert(buttonExists(with: identifier))
        
        app?.buttons[identifier].click()
            XCTAssertTrue(control.rating == 3)
        
    }
    
    func testResetRating() {
        XCTAssertTrue(isDisplayingRatingControl)
        guard let control = app?.otherElements["RatingControl"] as? RatingControl else { return }
        
        let identifier = "RatingButton-2"
        XCTAssert(buttonExists(with: identifier))
        
        app?.buttons[identifier].click()
        XCTAssertTrue(control.rating == 3)
        
        
        app?.buttons[identifier].click()
        XCTAssertTrue(control.rating == 0)
        
    }
    
}

extension StarRatingUITests {
    var isDisplayingRatingControl: Bool {
        guard let exists = app?.otherElements["RatingControl"].exists else { return false }
        return exists
    }
    
    func buttonExists(with identifier: String) -> Bool {
        guard let exists = app?.buttons[identifier].exists else { return false }
        return exists
    }
}
