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

	override func setUpWithError() throws {
		repository = DataRepository()
		favoriteViewModel = FavoriteListViewModel()
	}

	override func tearDownWithError() throws {
		repository.deleteAll()
	}

	func testSaveFilters() {

		selectedFirstname.id = 1
		selectedFirstname.firstname = "TestName"

		favoriteViewModel.selectedFirstname = selectedFirstname

		favoriteViewModel.saveFilters()

		let defaults = UserDefaults.standard
		// swiftlint:disable force_cast
		let retrievedFilters = defaults.object(forKey: "Filters") as! [String: AnyHashable]

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
