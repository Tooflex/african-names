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

	let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
			filter: "isFavorite = true")).sorted {
				return $0.firstname < $1.firstname
			}
        selectedFirstname = FirstnameDB()
    }

    func saveFilters() {
        let filters = [
            "isFavorite": true,
            "onTop": selectedFirstname.id
        ] as [String: Any]
        userDefaults.set(filters, forKey: "Filters")
    }

    func removeFromList(firstname: FirstnameDB) {
        dataRepository.toggleFavorited(firstnameObj: firstname)
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true"))
    }
}
