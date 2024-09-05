//
//  FavoriteListViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import Foundation
import SwiftUI

@MainActor
final class FavoriteListViewModel: ObservableObject {
    private let service: FirstNameService
    
    @Published var selectedFirstname: FirstnameDB?
    @Published var favoritedFirstnames: [FirstnameDB] = []
    
    init(service: FirstNameService) {
        self.service = service
        Task {
            await loadFavorites()
        }
    }
    
    func loadFavorites() async {
        do {
            favoritedFirstnames = try await service.getFavoritedFirstnames()
            favoritedFirstnames.sort { $0.firstname < $1.firstname }
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    func saveFilters() {
        guard let selectedFirstname = selectedFirstname else { return }
        let filters = [
            "isFavorite": true,
            "onTop": selectedFirstname.id
        ] as [String: Any]
        UserDefaults.standard.set(filters, forKey: "Filters")
    }
    
    func removeFromList(firstname: FirstnameDB) async {
        do {
            try await service.toggleFavorited(firstname: firstname)
            await loadFavorites()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}
