//
//  FavoriteListViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import Foundation

final class FavoriteListViewModel: ObservableObject {

    @Published var selectedFirstname: FirstnameDB

    let dataRepository = DataRepository.sharedInstance
    @Published var favoritedFirstnamesResults: [FirstnameDB]?

    init() {
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true"))
        selectedFirstname = FirstnameDB()
    }

    func saveFilters() {
        let filters = [
            "isFavorite": true,
            "onTop": selectedFirstname.id
        ] as [String: Any]
        UserDefaults.standard.set(filters, forKey: "Filters")
    }

    func removeFromList(firstname: FirstnameDB) {
        dataRepository.toggleFavorited(firstnameObj: firstname)
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true"))
    }
}
