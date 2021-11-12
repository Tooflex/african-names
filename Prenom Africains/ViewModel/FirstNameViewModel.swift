//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import RealmSwift

final class FirstNameViewModel: ObservableObject {

    let dataRepository = DataRepository.sharedInstance

    @Published var favoritedFirstnamesResults: Results<FirstnameDB>?
    @Published var firstnamesResults: Results<FirstnameDB>?

    var firstnamesToken: NotificationToken?
    @Published var isLoading = false
    @Published var isFiltered = false
    @Published var currentFirstname: FirstnameDB = FirstnameDB()
    var firstnameOnTop: FirstnameDB = FirstnameDB()

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    private var task: AnyCancellable?

    let username = "user"
    let password = "Manjack76"

    init() {
        isLoading = true
        dataRepository.fetchFirstnames { _ in
            self.getFirstnames()
            self.isLoading = false
        }
    }

    deinit {
        self.firstnamesToken?.invalidate()
    }

    func onAppear() {
       getFirstnames()
    }

    func clearFilters() {
        let filters = [String: Any]()
        print("My filters")
        print(filters)
        UserDefaults.standard.set(filters, forKey: "Filters")
        self.isFiltered = false
    }

    func getFirstnames() {
        let defaults = UserDefaults.standard
        let filters = defaults.object(forKey: "Filters") as? [String: Any] ?? [String: Any]()

        self.favoritedFirstnamesResults = dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true")
        self.firstnamesResults = dataRepository.fetchLocalData(type: FirstnameDB.self)

        if filters.isEmpty {
            self.isFiltered = false
            self.firstnamesResults = dataRepository.fetchLocalData(type: FirstnameDB.self)
        } else {
            self.isFiltered = true
            let filterOnTop = filters["onTop"] as? Int ?? -1
            if filterOnTop != -1 {
                firstnameOnTop = dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "localId = \(filterOnTop)").first ?? FirstnameDB()
            }

            let compoundFilter = self.createFilterCompound(filterArray: filters)
            do {
                try self.firstnamesResults = dataRepository.fetchLocalData(
                    type: FirstnameDB.self,
                    filter: compoundFilter)
            } catch {
                self.firstnamesResults = dataRepository.fetchLocalData(type: FirstnameDB.self)
                print("Errors in filtering")
            }

        }
        if firstnameOnTop.localId != 0 {
            // TODO: Put Selected firstname on top of list
        }
        self.currentFirstname = self.firstnamesResults?.first ?? FirstnameDB()
    }

    func toggleFavorited(firstnameObj: FirstnameDB) {
        objectWillChange.send()
        dataRepository.toggleFavorited(firstnameObj: firstnameObj)
    }

    private func activateFirstnamesToken() {
        let firstnames = self.dataRepository.fetchLocalData(type: FirstnameDB.self)
        self.firstnamesToken = firstnames.observe { _ in
            // When there is a change, replace the old firstnames array with a new one.
            self.firstnamesResults = self.dataRepository.fetchLocalData(type: FirstnameDB.self)
        }
    }

    private func createFilterCompound(filterArray: [String: Any]) -> NSCompoundPredicate {

        let filterIsFavorite = filterArray["isFavorite"] as? Bool ?? false
        let filterArea = filterArray["regions"] as? [String] ?? []
        let filterOrigins = filterArray["origins"] as? [String] ?? []
        let filterGender = filterArray["gender"] as? [String] ?? []
        let filterSize = filterArray["size"] as? [String] ?? []

        var subPredicates = [NSPredicate]()
        let favoritePredicate = NSPredicate(format: "isFavorite == %d", filterIsFavorite)
        subPredicates.append(favoritePredicate)

        if !filterArea.isEmpty {
            let areaPredicate = NSPredicate(format: "regions IN %@", filterArea)
            subPredicates.append(areaPredicate)
        }

        if !filterOrigins.isEmpty {
            let originsPredicate = NSPredicate(format: "origins IN %@", filterOrigins)
            subPredicates.append(originsPredicate)
        }

        if !filterGender.isEmpty {
            let genderPredicate = NSPredicate(format: "gender IN %@", filterGender)
            print(genderPredicate)
            subPredicates.append(genderPredicate)
        }

        if !filterSize.isEmpty {
            let sizePredicate = NSPredicate(format: "firstnameSize IN %@", filterSize)
            print(sizePredicate)
            subPredicates.append(sizePredicate)
        }

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)

        return compoundPredicate
    }

}
