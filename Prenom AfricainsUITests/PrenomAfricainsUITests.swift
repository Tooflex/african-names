//
//  Prenom_AfricainsUITests.swift
//  Prenom AfricainsUITests
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import XCTest

class PrenomAfricainsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation -
        // required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testMenuExists() throws {

        XCTAssert(app.buttons["Home"].exists)
        XCTAssert(app.buttons["Search"].exists)
        XCTAssert(app.buttons["My List"].exists)
        XCTAssert(app.buttons["Share"].exists)
        XCTAssert(app.buttons["Params"].exists)

    }

    func testGoToNextFirstname() throws {

        XCTAssert(app.staticTexts["current firstname"].exists)
        let text: String = app.staticTexts["current firstname"].value as? String ?? ""
        XCTAssert(app.otherElements["right button"].exists)
        app.otherElements["right button"].tap()
        let newText = app.staticTexts["current firstname"].value as? String ?? ""
        XCTAssert(text != newText)

    }

    func testGoToPreviousFirstname() throws {

        XCTAssert(app.otherElements["right button"].exists)
        app.otherElements["right button"].tap()
        XCTAssert(app.staticTexts["current firstname"].exists)
        let text: String = app.staticTexts["current firstname"].label
        XCTAssert(app.otherElements["left button"].exists)
        app.otherElements["left button"].tap()
        let newText = app.staticTexts["current firstname"].label
        XCTAssert(text != newText)

    }

    func testFavoriteIconChangeStateOnTap() throws {

        if app.otherElements["favorite button off"].exists {
            app.otherElements["favorite button off"].tap()
            XCTAssert(app.otherElements["favorite button on"].exists)
        } else if app.otherElements["favorite button on"].exists {
            app.otherElements["favorite button on"].tap()
            XCTAssert(app.otherElements["favorite button off"].exists)
        } else {
            XCTAssert(false, "No favorite button seems to be displayed")
        }

    }

    func testGenderIconIsCorrect() throws {
        XCTAssert(false)
    }

    func testDisplayMoreInfoPopUpOnTap() throws {
        XCTAssert(false)
    }

    func testFirstnameCircleDoNotMoveFollowingFirstnameLength() throws {
        XCTAssert(false)
    }

    func testGoToHomeScreenWhenTappingHomeButton() throws {
        XCTAssert(false)
    }

    func testGoToSearchScreenWhenTappingSearchButton() throws {
        XCTAssert(false)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
