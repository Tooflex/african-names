//
//  SearchScreenViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import Foundation
import Combine
import SwiftUI

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

    var tokens: Set<AnyCancellable> = []
    private var originsStr: [String] = []

    var listOfCriterias: [SearchCriteria] = []

    private let searchEndpoint = "/api/v1/firstnames/search/?search="
    private let orUrlSeparator = "*%20OR%20"

    let username = "user"
    let password = "Manjack76"

    /// OR separator to add between filters in filter firstname URLs
    let orStatement = " OR "
    let space = " "

    init() {
        self.selectedFirstnameInSearchResults = FirstnameDB()

        self.fetchOrigins()

        // Fill Size Options
        for size in fetchSizes() {
            sizes.append(ChipsDataModel(isSelected: false, titleKey: size))
        }

        // Fill Area Options
        for area in fetchAreas() {
            areas.append(ChipsDataModel(isSelected: false, titleKey: area))
        }

    }

    /// Search firstname in remote storage
    func searchFirstnamesRemote(searchString: String) {
        print("Calling searchFirstnames")
        dataRepository.searchFirstname(searchString: searchString) { _ in
            self.loading = false
        }
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

    /// Filter firstnames in remote
    func filterFirstnamesRemote() {
        print("Calling filterFirstnames")
        formatFilterString(currentFilterChain)

        dataRepository.filterFirstnamesRemote(filterChain: currentFilterChain) { response in
            switch response.result {
                case .success(let model):
                    self.loading = false
                    print(model.count)

                case .failure(let error):
                    print(error)
                    print("Called failed look into local")
            }
        }
    }

    // Tester IN avec liste
    // Tester Predicate with IN operator must compare a Key2Path with an aggregate
    func filterFirstnamesLocal() -> NSCompoundPredicate {

        var subPredicates = [NSPredicate]()
        let favoritePredicate = NSPredicate(format: "isFavorite == %d", filterIsFavorite)
        subPredicates.append(favoritePredicate)

        if !filterArea.isEmpty {
            let areaPredicate = NSPredicate(format: "regions IN %@", filterArea)
            subPredicates.append(areaPredicate)
        }

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)

        return compoundPredicate
    }

    func fetchSizes() -> [String] {
        return ["short", "medium", "long"]
    }

    func fetchAreas() -> [String] {
        return ["north africa", "east africa", "west africa", "south africa"]
    }

    func fetchOrigins() {
        print("Calling get origins")

        dataRepository.fetchOrigins { response in
            switch response.result {
            case .success(let model):
                self.originsStr = model
                self.loading = false
                // Fill Origins Options
                for origin in self.originsStr {
                    self.origins.append(ChipsDataModel(isSelected: false, titleKey: origin))
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: Filter related

    func initFilters() {
        let defaults = UserDefaults.standard
        let filters = defaults.object(forKey: "Filters") as? [String: Any] ?? [String: Any]()

        if let isFavorite = filters["isFavorite"] as? Bool {
            self.filterIsFavorite = isFavorite
        } else {
            self.filterIsFavorite = false
        }

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

        if let size = filters["size"] as? [String] {
            self.filterSize = size

            for itemSizes in self.sizes {
                if self.filterOrigins.contains(itemSizes.titleKey.capitalized) {
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

    /*
     Add in User Defaults the id of the chosen firstname in search results
     */
    func goToChosenFirstname() {
        let filters = [
            "onTop": selectedFirstnameInSearchResults.id
        ] as [String: Any]
        UserDefaults.standard.set(filters, forKey: "Filters")
    }

    /**
     Add a new filter to the current filter chain.
     
     - Parameter newFilter: The field to filter.
     - Parameter newFilterValue: The value to filter with.
    
     */
    func addToFilterChainString(newFilter: String, newFilterValue: String) {
        listOfCriterias.append(SearchCriteria(filter: newFilter, filterValue: newFilterValue))
    }

    /**
     Remove a filter from the filter chain.
     
     - Parameter filterValueToRemove: the filter value to remove.
     */
    func removeFromFilterChainString(filterToRemove: String, filterValueToRemove: String) {
        listOfCriterias.removeAll {  $0.filterValue == filterValueToRemove && $0.filter == filterToRemove}
    }

    /**
     Format the filter string so we can add it to an URL.
     
     - Parameter filterString: Filter string to format.
     */
    func formatFilterString(_ filterString: String) {

        currentFilterChain.removeAll()

        for criteria in listOfCriterias {
            if currentFilterChain.isEmpty {
                currentFilterChain = "\(criteria.filter):\(criteria.filterValue)"
            } else {
                currentFilterChain.append(orStatement+"\(criteria.filter):\(criteria.filterValue)")
            }
        }

        currentFilterChain = currentFilterChain.replacingOccurrences(of: space, with: "%20")
        currentFilterChain = currentFilterChain.lowercased()
        print(currentFilterChain)
    }
}
