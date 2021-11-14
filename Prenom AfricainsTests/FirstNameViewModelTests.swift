//
//  FirstNameViewModelTests.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 11/11/2021.
//

import XCTest
@testable import Prenom_Africains

class FirstNameViewModelTests: XCTestCase {

    var repository: DataRepository!

    var prenom: FirstnameDataModel!

    var firstNameViewModel: FirstNameViewModel!

    override func setUpWithError() throws {
        repository = DataRepository()
        prenom = FirstnameDataModel()
        firstNameViewModel = FirstNameViewModel()
    }

    override func tearDownWithError() throws {
        repository.deleteAll()
        prenom = nil

    }

    func testGetFirstnames() throws {
        repository.add(firstname: prenom)

        firstNameViewModel.getFirstnames()

        let firstNameRetrieved = FirstnameDataModel(firstnameDB: (firstNameViewModel.firstnamesResults?.first)!)

        XCTAssert(firstNameRetrieved == prenom)

    }

    // func test

    func testPerformanceExample() throws {

        self.measure {

        }
    }

}
