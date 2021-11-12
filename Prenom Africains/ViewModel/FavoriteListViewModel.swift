//
//  FavoriteListViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import Foundation
import RealmSwift

final class FavoriteListViewModel: ObservableObject {

    let dataRepository = DataRepository.sharedInstance
    @Published var favoritedFirstnamesResults: Results<FirstnameDB>?

    init() {
        self.favoritedFirstnamesResults =
        dataRepository.fetchLocalData(type: FirstnameDB.self, filter: "isFavorite = true")
    }
}
