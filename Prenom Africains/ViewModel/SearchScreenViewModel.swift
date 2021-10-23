//
//  SearchScreenViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import RealmSwift

final class SearchScreenViewModel: ObservableObject {

    let realm = DataRepository.sharedInstance

    /// Contains array of firstname objects by filter
    @Published var searchResults: Results<FirstnameDB>?
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
    @Published var filterGender = []
    @Published var filterOrigins = []
    @Published var filterSize = []
    @Published var filterArea = []
    @Published var filterFemale = false
    @Published var filterMale = false

    var tokens: Set<AnyCancellable> = []
    private var originsStr: [String] = []

    var listOfCriterias: [SearchCriteria] = []

    private let apiDomain = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    private let searchEndpoint = "/api/v1/firstnames/search/?search="
    private let orUrlSeparator = "*%20OR%20"

    let username = "user"
    let password = "Manjack76"

    /// OR separator to add between filters in filter firstname URLs
    let orStatement = " OR "
    let space = " "

    init() {
        self.getOrigins()

        // Fill Size Options
        for size in getSizes() {
            sizes.append(ChipsDataModel(isSelected: false, titleKey: size))
        }

        // Fill Area Options
        for area in getAreas() {
            areas.append(ChipsDataModel(isSelected: false, titleKey: area))
        }
    }

    func searchFirstnamesRemote(searchString: String) {
        print("Calling searchFirstnames")

        if !searchString.isEmpty {
            if let apiEndpoint = apiDomain {
                let url =
            """
            \(apiEndpoint)\(searchEndpoint)firstname:\(searchString)\(orUrlSeparator)origins:\(searchString)*
            """
                print(url)

                let headers: HTTPHeaders = [.authorization(username: username, password: password)]

                AF.request(url, headers: headers)
                    .validate()
                    .publishDecodable(type: [FirstnameDataModel].self)
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .finished:
                                ()
                        case .failure(let error):
                                print(error.localizedDescription)
                        }
                    }, receiveValue: { (response) in
                        switch response.result {
                        case .success(let model):
                                // self.searchResults = model
                                self.loading = false

                        case .failure(let error):
                                print(error.localizedDescription)
                        }
                    }).store(in: &tokens)
            } else {
                return
            }
        }
    }

    /// Search names in local storage
    func searchFirstnamesLocal(searchString: String) {
        print("Searching firstnames in local")

        if !searchString.isEmpty {
            let predicate = NSPredicate(format: "firstname CONTAINS[d] %@", searchString)
            do {
                try
            self.searchResults = realm.fetchData(type: FirstnameDB.self, filter: predicate)
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
        if let apiEndpoint = apiDomain {

            let url =
            """
            \(apiEndpoint)\(searchEndpoint)\(currentFilterChain)
            """

            print("URL called: \(url)")

            let headers: HTTPHeaders = [.authorization(username: username, password: password)]

            AF.request(url, headers: headers)
                .validate()
                .publishDecodable(type: [FirstnameDataModel].self)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                            ()
                    case .failure(let error):
                            print(error.localizedDescription)
                    }
                }, receiveValue: { (response) in
                    switch response.result {
                    case .success(let model):
                            // self.searchResults = model
                            self.loading = false
                            print(model.count)

                    case .failure(let error):
                            print(error.localizedDescription)
                            print("Called failed look into local")
                            self.filterFirstnamesLocal()
                    }
                }).store(in: &tokens)
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

    func saveFilters() {
        let filters = ["isFavorite": filterIsFavorite,
                       "regions": filterArea,
                       "origins": filterOrigins,
                       "gender": filterGender] as [String: Any]
        print("My filters")
        print(filters)
        UserDefaults.standard.set(filters, forKey: "Filters")
    }

    func getSizes() -> [String] {
        return ["short", "medium", "long"]
    }

    func getAreas() -> [String] {
        return ["north africa", "east africa", "west africa", "south africa"]
    }

    func getOrigins() {
        print("Calling get origins")

        if let apiEndpoint = apiDomain {

            let url = "\(apiEndpoint)/api/v1/origins"

        let headers: HTTPHeaders = [.authorization(username: username, password: password)]

        AF.request(url, headers: headers)
            .validate()
            .publishDecodable(type: [String].self)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                        ()
                case .failure(let error):
                        print(error.localizedDescription)
                }
            }, receiveValue: { [self] (response) in
                switch response.result {
                case .success(let model):
                    originsStr = model
                    loading = false
                    // Fill Origins Options
                    for origin in originsStr {
                        origins.append(ChipsDataModel(isSelected: false, titleKey: origin))
                    }

                case .failure(let error):
                        print(error.localizedDescription)
                }
            }).store(in: &tokens)
        }
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
