//
//  SearchScreenViewModelTest.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 25/11/2021.
//

import XCTest
@testable import Prenom_Africains
@testable import Alamofire

class SearchScreenViewModelTest: XCTestCase {

	var repository: DataRepository!
	var manager: Session!
	private var firstnameApiService: FirstNameApiService!
	private let apiEndpoint = API.baseURL
	private var searchScreenViewModel: SearchScreenViewModel!

	override func setUpWithError() throws {
		manager = {
			let configuration: URLSessionConfiguration = {
				let configuration = URLSessionConfiguration.af.default
				configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
				return configuration
			}()

			return Session(configuration: configuration)
		}()
		repository = DataRepository()
		searchScreenViewModel = SearchScreenViewModel()
	}

	func testSearchFirstnamesRemote() {
		searchScreenViewModel.searchFirstnamesRemote(searchString: "firstname=Amadou")
	}

	func testsearchFirstnamesLocal() {

	}

	func testfilterFirstnamesRemote() {

	}

	func testfilterFirstnamesLocal() {

	}

	func testFetchOrigins() {

	}

	func testInitFilters() {

	}

	func testSaveFilters() {

	}

	func testgoToChosenFirstname() {

	}

	func addToFilterChainString() {

	}

	func removeFromFilterChainString() {

	}

	func formatFilterString() {

	}

}
