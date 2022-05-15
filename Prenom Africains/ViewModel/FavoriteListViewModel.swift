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
<<<<<<< HEAD
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(
            type: FirstnameDB.self,
            filter: "isFavorite = true"))
=======
        self.favoritedFirstnamesResults = Array(dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "isFavorite = true"))
>>>>>>> 295398ac63e95da164a5e7c313cdbaca972d2f17
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
