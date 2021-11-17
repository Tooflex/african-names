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

        let firstNameRetrieved = FirstnameDataModel(firstnameDB: (firstNameViewModel.firstnamesResults.first)!)

        XCTAssert(firstNameRetrieved == prenom)

    }

    func testClearFilters() throws {

        var filters = ["isFavorite": "true",
                       "regions": ["reg1", "reg2"],
                       "origins": ["org1", "org2"],
                       "gender": [Gender.male.rawValue, Gender.mixed.rawValue],
                       "size": [Size.long.rawValue]] as [String: Any]
        UserDefaults.standard.set(filters, forKey: "Filters")

        firstNameViewModel.clearFilters()

        let defaults = UserDefaults.standard

        // swiftlint:disable force_cast
        filters = defaults.object(forKey: "Filters") as! [String: Any]

        XCTAssertTrue(filters.isEmpty)

    }

    func testCreateFilterCompound() {
        //TODO:
    }

    func testToggleFavorite() throws {
        let firstnameToTest = FirstnameDB()
        XCTAssertFalse(firstnameToTest.isFavorite)
        firstNameViewModel.toggleFavorited(firstnameObj: firstnameToTest)
        let firstnameFromDB = repository.fetchLocalData(type: FirstnameDB.self).first!
        XCTAssertTrue(firstnameFromDB.isFavorite)

    }

    // func test

//    func testPerformanceExample() throws {
//
//        self.measure {
//
//        }
//    }

}
