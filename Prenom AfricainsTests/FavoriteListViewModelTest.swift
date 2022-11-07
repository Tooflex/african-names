//
//  FavoriteListViewModelTest.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 25/11/2021.
//

import XCTest
@testable import Prenom_Africains
@testable import Alamofire

class FavoriteListViewModelTest: XCTestCase {

	var repository: DataRepository!
	var favoriteViewModel: FavoriteListViewModel!
	var selectedFirstname = FirstnameDB()
	var userDefaults: UserDefaults = UserDefaults(suiteName: #file)!

	override func setUpWithError() throws {
		userDefaults = UserDefaults(suiteName: #file)!
		userDefaults.removePersistentDomain(forName: #file)

		userDefaults.set([], forKey: "Filters")

		repository = DataRepository()
		favoriteViewModel = FavoriteListViewModel(userDefaults: userDefaults)
	}

	override func tearDownWithError() throws {
		repository.deleteAll()
	}

	func testSaveFilters() {

		selectedFirstname.id = 1
		selectedFirstname.firstname = "TestName"

		favoriteViewModel.selectedFirstname = selectedFirstname

		favoriteViewModel.saveFilters()

		// swiftlint:disable force_cast
		let retrievedFilters = userDefaults.object(forKey: "Filters") as! [String: AnyHashable]

		let filters = [
			"isFavorite": true,
			"onTop": selectedFirstname.id
		] as [String: AnyHashable]

		XCTAssert(retrievedFilters.elementsEqual(filters) { $0.key == $1.key && $0.value == $1.value
		})

	}

	func testRemoveFromList() {

	}

}
