//
//  ContentViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 15/10/2022.
//

import SwiftUI
import L10n_swift

@MainActor
class ContentViewModel: ObservableObject {

	@Published var selectedTab: Tab
	@Published var currentFirstname: FirstnameDB
	@Published var isLanguageChanged: Bool
	@Published var searchString: NSCompoundPredicate
	@Published var isFirstLaunch: Bool
    
    private let service: FirstNameService

	init(service: FirstNameService) {
        self.service = service
		selectedTab = Tab.home
		currentFirstname = FirstnameDB()
		isLanguageChanged = false
		isFirstLaunch = true
		searchString = NSCompoundPredicate()
	}

	func checkDeepLink(url: URL) -> Bool {
		guard let host = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			return false
		}

		print(host.queryItems ?? [])

		switch host.queryItems?.first?.name {
			case "tab":
				switch host.queryItems?.first?.value {
					case Tab.home.rawValue:
						selectedTab = .home
					case Tab.search.rawValue:
						selectedTab = .search
					case Tab.list.rawValue:
						selectedTab = .list
					case Tab.param.rawValue:
						selectedTab = .param

					default: return false

				}
			case "name":
				if let name = host.queryItems?.first?.value {
					return getFirstnameFromLink(name: name)
				} else {
					return false
				}

			default: return false

		}
		print(selectedTab.rawValue)
		return true
	}

	func getFirstnameFromLink(name: String) -> Bool {
        var firstnamesResults = Array(service.getLocalFirstnames().shuffled())

		if let firstnameToPutOnTop = firstnamesResults.filter({ $0.firstname.lowercased() == name.lowercased() }).first {
			firstnamesResults.move(firstnameToPutOnTop, to: 0)
			currentFirstname = firstnameToPutOnTop
			goToChosenFirstname()
			selectedTab = .home
			return true
		}

		return false
	}

	/**
	 Add in User Defaults the id of the chosen firstname in search results
	 */
	func goToChosenFirstname() {
		let filters = [
			"onTop": currentFirstname.id
		] as [String: Any]
		UserDefaults.standard.set(filters, forKey: "Filters")
	}
}

enum Tab: String {
	case home = "home"
	case search = "search"
	case list = "list"
	case param = "params"
}
