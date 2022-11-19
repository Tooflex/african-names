//
//  SearchScreenViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import Foundation
import Combine
import SwiftUI
import L10n_swift

final class SearchScreenViewModel: ObservableObject {

    let dataRepository = DataRepository.sharedInstance

    /// Contains array of firstname objects by filter
    @Published var searchResults: [FirstnameDB] = []
    @Published var loading = false

    @Published var firstnames = [FirstnameDB]()
    @Published var favoritedFirstnames = [FirstnameDB]()

    @Published var sizes: [ChipsDataModel] = []
    @Published var areas: [ChipsDataModel] = []
    @Published var origins: [ChipsDataModel] = []

    /// The filter string to add to the search URL
    @Published var currentFilterChain = ""

    /// The locals filters
    @Published var filterIsFavorite = false
    @Published var filterGender = [String]()
    @Published var filterOrigins = [String]()
	@Published var filterSize = [String]()
    @Published var filterArea = [String]()
    @Published var filterFemale = false
    @Published var filterMale = false

    @Published var selectedFirstnameInSearchResults: FirstnameDB

    init() {
        self.selectedFirstnameInSearchResults = FirstnameDB()
        // Fill Size Options
        for size in fetchSizes() {
            sizes.append(ChipsDataModel(isSelected: false, titleKey: size, displayedTitle: size.l10n(resource: "en").l10n() ))
        }

        // Fill Area Options
        for area in fetchAreas() {
            areas.append(ChipsDataModel(isSelected: false, titleKey: area, displayedTitle: area.l10n()))
        }

    }

    func fetchSizes() -> [String] {
        return ["short", "medium", "long"]
    }

    func fetchAreas() -> [String] {
        return ["northern africa", "eastern africa", "western africa", "southern africa"]
    }

    // MARK: Filter related

	fileprivate func initFavoriteFilter(_ filters: [String: Any]) {
		if let isFavorite = filters["isFavorite"] as? Bool {
			self.filterIsFavorite = isFavorite
		} else {
			self.filterIsFavorite = false
		}
	}

	fileprivate func initAreasFilter(_ filters: [String: Any]) {
		if let regions = filters["regions"] as? [String] {
			self.filterArea = regions

			for itemArea in self.areas {
				if self.filterArea.contains(itemArea.titleKey.capitalized) {
					itemArea.isSelected = true
				}
			}

		} else {
			self.filterArea = []
			self.areas.forEach { chip in
				chip.isSelected = false
			}
		}
	}

	fileprivate func initOriginsFilter(_ filters: [String: Any]) {
		if let origins = filters["origins"] as? [String] {
			self.filterOrigins = origins

			for itemOrigins in self.origins {
				if self.filterOrigins.contains(itemOrigins.titleKey.capitalized) {
					itemOrigins.isSelected = true
				}
			}

		} else {
			self.filterOrigins = []
			self.origins.forEach { chip in
				chip.isSelected = false
			}
		}
	}

	fileprivate func initGenderFilter(_ filters: [String: Any]) {
		if let gender = filters["gender"] as? [String] {
			self.filterGender = gender
			print(filters["gender"].debugDescription)
			if gender.contains("male") {
				self.filterMale = true
			}
			if gender.contains("female") {
				self.filterFemale = true
			}

		} else {
			self.filterGender = []
			self.filterMale = false
			self.filterFemale = false
		}
	}

	fileprivate func initSizeFilter(_ filters: [String: Any]) {
		if let size = filters["size"] as? [String] {
			self.filterSize = size

			for itemSizes in self.sizes {
				if self.filterSize.contains(itemSizes.titleKey.capitalized) {
					itemSizes.isSelected = true
				}
			}

		} else {
			self.filterSize = []
			self.sizes.forEach { chip in
				chip.isSelected = false
			}
		}
	}

	func initFilters() {
        let defaults = UserDefaults.standard
        let filters = defaults.object(forKey: "Filters") as? [String: Any] ?? [String: Any]()

		initFavoriteFilter(filters)

		initAreasFilter(filters)

		initOriginsFilter(filters)

		initGenderFilter(filters)

		initSizeFilter(filters)

    }

    /**
     Save the filters in UserDefaults
     */
    func saveFilters() {
        let filters = ["isFavorite": filterIsFavorite,
                       "regions": filterArea,
                       "origins": filterOrigins,
                       "gender": filterGender,
                       "size": filterSize] as [String: Any]
        print("My filters")
        print(filters)
        UserDefaults.standard.set(filters, forKey: "Filters")
    }

    /**
     Add in User Defaults the id of the chosen firstname in search results
     */
    func goToChosenFirstname() {
        let filters = [
            "onTop": selectedFirstnameInSearchResults.id
        ] as [String: Any]
        UserDefaults.standard.set(filters, forKey: "Filters")
    }

	/// Search names in local storage
	func searchFirstnamesLocal(searchString: String) {
		print("Searching firstnames in local")

		if !searchString.isEmpty {
			let predicate = NSPredicate(format: "firstname CONTAINS[d] %@", searchString)
			do {
				try
				self.searchResults = Array(dataRepository.fetchLocalData(type: FirstnameDB.self, filter: predicate))
			} catch {
				print("Error")
			}
			print(searchString.propertyList())
		}
	}
}
