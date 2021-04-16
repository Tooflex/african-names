//
//  Prenom_AfricainsTests.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import XCTest
@testable import Prenom_Africains

class Prenom_AfricainsTests: XCTestCase {
    
    var prenom: PrenomAF!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        prenom = PrenomAF()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        prenom = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
