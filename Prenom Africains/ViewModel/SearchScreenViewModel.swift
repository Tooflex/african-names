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

final class SearchScreenViewModel: ObservableObject {

    /// Contains array of firstname objects by filter
    @Published var searchResults = [FirstnameDataModel]()
    @Published var loading = false

    @Published var sizes: [ChipsDataModel] = []
    @Published var areas: [ChipsDataModel] = []
    @Published var origins: [ChipsDataModel] = []

    /// The filter string to add to the search URL
    @Published var currentFilterChain = ""

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

    func searchFirstnames(searchString: String) {
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
                                self.searchResults = model
                                self.loading = false

                        case .failure(let error):
                                print(error.localizedDescription)
                        }
                    }).store(in: &tokens)
            } else {
                return
            }
        } else {
            // TODO: Return all firstnames
        }

    }

    func filterFirstnames() {
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
                            self.searchResults = model
                            self.loading = false
                            print(model.count)

                    case .failure(let error):
                            print(error.localizedDescription)
                    }
                }).store(in: &tokens)
        }
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
