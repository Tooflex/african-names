//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation

final class FirstNameViewModel: ObservableObject {

    private let dataRepository = DataRepository.sharedInstance

    @Published var favoritedFirstnamesResults: [FirstnameDB] = []
    @Published var firstnamesResults: [FirstnameDB] = []

    @Published var isLoading = false
    @Published var isFiltered = false
    @Published var noResults = false // No filter results
    @Published var noData = false // No firstnames in DB

    @Published var currentFirstname: FirstnameDB = FirstnameDB()
    var firstnameOnTop: FirstnameDB = FirstnameDB()

    init() {
        getFirstnames()
        fetchOnline()
    }

    func onAppear() {
       getFirstnames()
    }

    /// Clear filters from UserDefaults
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

        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true"))
        self.firstnamesResults = Array(dataRepository.fetchLocalData(type: FirstnameDB.self))

        if filters.isEmpty {
            self.isFiltered = false
            self.firstnamesResults = Array(dataRepository.fetchLocalData(type: FirstnameDB.self)).shuffled()
        } else {
            self.isFiltered = true
            let filterOnTop = filters["onTop"] as? Int ?? -1
            if filterOnTop != -1 {
                firstnameOnTop = dataRepository.fetchLocalData(
                    type: FirstnameDB.self,
                    filter: "id = \(filterOnTop)").first ?? FirstnameDB()
            }

            let compoundFilter = self.createFilterCompound(filterArray: filters)
            do {
                try self.firstnamesResults = Array(dataRepository.fetchLocalData(
                    type: FirstnameDB.self,
                    filter: compoundFilter)).shuffled()
            } catch {
                self.firstnamesResults = Array(dataRepository.fetchLocalData(type: FirstnameDB.self)).shuffled()
                print("Errors in filtering")
            }

        }
        // Put chosen firstname from favorite list first in main screen
        if firstnameOnTop.id != 0 {
            if let firstnameToPutOnTop = self.firstnamesResults.filter({ $0.id == firstnameOnTop.id }).first {
                self.firstnamesResults.move(firstnameToPutOnTop, to: 0)
            }
        }

        if let firstFirstname = self.firstnamesResults.first {
            self.currentFirstname = firstFirstname
            self.noResults = false
        } else {
            self.noResults = true
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDB) {
        objectWillChange.send()
        dataRepository.toggleFavorited(firstnameObj: firstnameObj)
    }

    func fetchOnline() {
        if noResults {
            isLoading = true
        }
        dataRepository.fetchFirstnames { response in

            switch response.result {
            case .success(_):
                if self.noResults {
                    self.getFirstnames()
                } else {
                    print("Firstnames updated silently")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }

    private func createFilterCompound(filterArray: [String: Any]) -> NSCompoundPredicate {

        let filterIsFavorite = filterArray["isFavorite"] as? Bool
        let filterArea = filterArray["regions"] as? [String] ?? []
        let filterOrigins = filterArray["origins"] as? [String] ?? []
        let filterGender = filterArray["gender"] as? [String] ?? []
        let filterSize = filterArray["size"] as? [String] ?? []

        var subPredicates = [NSPredicate]()
        let favoritePredicate = NSPredicate(format: "isFavorite == %d", filterIsFavorite ?? false)
        subPredicates.append(favoritePredicate)

        if filterArea.isEmpty && filterOrigins.isEmpty && filterGender.isEmpty && filterSize.isEmpty && (filterIsFavorite == nil || !filterIsFavorite!) {
            self.clearFilters()
        }

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
