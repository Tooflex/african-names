//
//  DataRepositoryTest.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 11/11/2021.
//

import XCTest
@testable import Prenom_Africains

class DataRepositoryTest: XCTestCase {
    var dataRepository: DataRepository!
    var firstameToTest: FirstnameDataModel!

    override func setUpWithError() throws {
        firstameToTest = FirstnameDataModel()
        dataRepository = DataRepository()
    }

    override func tearDownWithError() throws {
        dataRepository.deleteAll()
        dataRepository = nil
        firstameToTest = nil
    }

    func testAddFirstname() throws {
        firstameToTest.firstname = "Toto"
        firstameToTest.isFavorite = true

        dataRepository.add(firstname: firstameToTest)
        let fetchedFirstnames = dataRepository.fetchLocalData(type: FirstnameDB.self)

        XCTAssert(!fetchedFirstnames.isEmpty)

        let fetchedFirstname = FirstnameDataModel(firstnameDB: fetchedFirstnames.first!)

        XCTAssert(fetchedFirstname.id == firstameToTest.id)

        XCTAssert(fetchedFirstname.origins == firstameToTest.origins)

        XCTAssert(fetchedFirstname.firstname == firstameToTest.firstname)

        XCTAssert(fetchedFirstname.regions == firstameToTest.regions)

        XCTAssert(fetchedFirstname.meaning == firstameToTest.meaning)

        XCTAssert(fetchedFirstname.soundURL == firstameToTest.soundURL)

        XCTAssert(fetchedFirstname.isFavorite == firstameToTest.isFavorite)
    }

    fileprivate func createSetOfFirstnamesDataModels() -> [FirstnameDataModel] {
        var firstname1 = FirstnameDataModel()
        var firstname2 = FirstnameDataModel()
        var firstname3 = FirstnameDataModel()
        var firstname4 = FirstnameDataModel()

        // Creation of first firstname
        firstname1.id = 0
        firstname1.firstname = "Toto1"
        firstname1.meaning = "Meaning1"
        firstname1.soundURL = "http://sounds.com/sound1"
        firstname1.regions = "Region 1"
        firstname1.origins = "Origin 1"
        firstname1.size = Size.medium

        // Creation of second firstname
        firstname2.id = 1
        firstname2.firstname = "Toto2"
        firstname2.meaning = "Meaning2"
        firstname2.soundURL = "http://sounds.com/sound2"
        firstname2.regions = "Region 2"
        firstname2.origins = "Origin 2"
        firstname2.size = Size.medium

        // Creation of third firstname
        firstname3.id = 2
        firstname3.firstname = "Toto3"
        firstname3.meaning = "Meaning3"
        firstname3.soundURL = "http://sounds.com/sound3"
        firstname3.regions = "Region 3"
        firstname3.origins = "Origin 3"
        firstname3.size = Size.medium

        // Creation of fourth firstname
        firstname4.id = 3
        firstname4.firstname = "Toto4"
        firstname4.meaning = "Meaning4"
        firstname4.soundURL = "http://sounds.com/sound4"
        firstname4.regions = "Region 4"
        firstname4.origins = "Origin 4"
        firstname4.size = Size.medium

        var firstnames = [FirstnameDataModel]()
        firstnames.append(firstname1)
        firstnames.append(firstname2)
        firstnames.append(firstname3)
        firstnames.append(firstname4)

        return firstnames
    }

    func testAddAllFirstnames() throws {

        let firstnames = createSetOfFirstnamesDataModels()

        dataRepository.addAll(firstnamesToAdd: firstnames)
        let retrievedFirstname1 = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "id = 0")
        let retrievedFirstname2 = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "id = 1")
        let retrievedFirstname3 = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "id = 2")
        let retrievedFirstname4 = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "id = 3")

        XCTAssert(FirstnameDataModel(firstnameDB: retrievedFirstname1.first!) == firstnames[0])
        XCTAssert(FirstnameDataModel(firstnameDB: retrievedFirstname2.first!) == firstnames[1])
        XCTAssert(FirstnameDataModel(firstnameDB: retrievedFirstname3.first!) == firstnames[2])
        XCTAssert(FirstnameDataModel(firstnameDB: retrievedFirstname4.first!) == firstnames[3])

    }

    func testUpdateFirstnames() {

        // Step 1: Create a firstname & add it to the database
        firstameToTest.firstname = "Toto not updated"
        dataRepository.add(firstname: firstameToTest)

        // Step 2: Fetch the added firstname
        let retrievedFirstname = dataRepository.fetchLocalData(type: FirstnameDB.self).first!
        XCTAssert(retrievedFirstname.firstname == "Toto not updated")

        // Step 3: Modify the firstname
        retrievedFirstname.firstname = "Toto updated"
        retrievedFirstname.gender = Gender.male.rawValue
        retrievedFirstname.meaning = "meaning updated"
        retrievedFirstname.origins = "origin updated"
        retrievedFirstname.firstnameSize = Size.long.rawValue
        retrievedFirstname.soundURL = "soundurl updated"
        retrievedFirstname.regions = "region updated"

        dataRepository.update(firstname: retrievedFirstname)

        let retrievedFirstnameAfterUpdated = FirstnameDataModel(
            firstnameDB: dataRepository.fetchLocalData(type: FirstnameDB.self).first!
        )

        XCTAssert(retrievedFirstnameAfterUpdated.firstname == "Toto updated")
        XCTAssert(retrievedFirstnameAfterUpdated.gender == Gender.male)
        XCTAssert(retrievedFirstnameAfterUpdated.meaning == "meaning updated")
        XCTAssert(retrievedFirstnameAfterUpdated.origins == "origin updated")
        XCTAssert(retrievedFirstnameAfterUpdated.size == Size.undefined)
        XCTAssert(retrievedFirstnameAfterUpdated.soundURL == "soundurl updated")
        XCTAssert(retrievedFirstnameAfterUpdated.regions == "region updated")

    }

    func testDeleteAllFirstnames() {
        let firstname1 = FirstnameDataModel()
        let firstname2 = FirstnameDataModel()
        let firstname3 = FirstnameDataModel()
        let firstname4 = FirstnameDataModel()

        dataRepository.addAll(firstnamesToAdd: [firstname1, firstname2, firstname3, firstname4])

        var retrivedFirstnames = dataRepository.fetchLocalData(type: FirstnameDB.self)

        XCTAssert(retrivedFirstnames.count == 4)
        dataRepository.deleteAll()

        retrivedFirstnames = dataRepository.fetchLocalData(type: FirstnameDB.self)
        XCTAssert(retrivedFirstnames.count == 0)

    }

    func testFetchLocalDataWithStringPredicates() {
        var firstname1 = FirstnameDataModel()
        let firstname2 = FirstnameDataModel()
        var firstname3 = FirstnameDataModel()
        let firstname4 = FirstnameDataModel()

        firstname1.isFavorite = true
        firstname3.isFavorite = true

        dataRepository.addAll(firstnamesToAdd: [firstname1, firstname2, firstname3, firstname4])

        let filteredFirstname = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "isFavorite == true")

        XCTAssert(filteredFirstname.count == 2)

    }

    func testFetchLocalDataWithPredicates() {
        var firstname1 = FirstnameDataModel()
        let firstname2 = FirstnameDataModel()
        var firstname3 = FirstnameDataModel()
        let firstname4 = FirstnameDataModel()

        firstname1.isFavorite = true
        firstname3.isFavorite = true

        let favoritePredicate = NSPredicate(format: "isFavorite == true")

        dataRepository.addAll(firstnamesToAdd: [firstname1, firstname2, firstname3, firstname4])
        do {
            let filteredFirstname =  try dataRepository.fetchLocalData(
                type: FirstnameDB.self,
                filter: favoritePredicate
            )
            XCTAssert(filteredFirstname.count == 2)
        } catch {
            print(error)
        }
    }

    func testFetchFirstnames() {
        // TODO
    }

    func testToggleFavorite() {
        // TODO
    }

    func testPerformanceExample() throws {

        self.measure {
            // TODO
        }
    }

}
