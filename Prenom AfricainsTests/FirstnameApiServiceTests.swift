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

    var manager: Session!
    private var firstnameApiService: FirstNameApiService!
    private let apiEndpoint = API.baseURL

    override func setUpWithError() throws {
        manager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.af.default
                configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
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
        let expectedFirstname = FirstnameDataModel()
        let expectation = XCTestExpectation(description: "Performs a request")

        // when
        guard let url = URL(string: "\(apiEndpoint)/api/v1/firstnames/random" ) else {
            print("Error: cannot create URL")
            return
        }

        let headers: HTTPHeaders = [.authorization(username: "user", password: "mdp")]
        // swiftlint:disable force_try
        let mockedData = try! JSONEncoder().encode(expectedFirstname)
        let mock = Mock(url: url, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        manager.request(url, headers: headers)
            .responseDecodable(of: FirstnameDataModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertEqual(response.value, expectedFirstname)
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
