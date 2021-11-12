//
//  FirstnameApiServiceTests.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 12/11/2021.
//

import XCTest
@testable import Prenom_Africains
@testable import Alamofire

class FirstnameApiServiceTests: XCTestCase {

    private var firstnameApiService: FirstNameApiService!

    override func setUpWithError() throws {
        let manager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()

            return Session(configuration: configuration)
        }()
        firstnameApiService = FirstNameApiService(manager: manager)
    }

    override func tearDownWithError() throws {
        firstnameApiService = nil
    }

    func testFetchFirstnames() throws {
        // given
        MockURLProtocol.responseWithStatusCode(code: 200)

        let expectation = XCTestExpectation(description: "Performs a request")

        // when
        firstnameApiService.fetchFirstnames { firstnames in
            XCTAssert(firstnames.count > 0)
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
