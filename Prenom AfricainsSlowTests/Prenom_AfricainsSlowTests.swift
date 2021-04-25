//
//  Prenom_AfricainsSlowTests.swift
//  Prenom AfricainsSlowTests
//
//  Created by Otourou Da Costa on 17/04/2021.
//

import XCTest
import Alamofire
import Combine
@testable import Prenom_Africains



class Prenom_AfricainsSlowTests: XCTestCase {
    let networkMonitor = NetworkMonitor.shared


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
