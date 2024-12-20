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
        var filters = Filters()
        
        if let selectedFirstname = selectedFirstname {
            filters.isFavorite = true
            filters.onTop = selectedFirstname.id
        }
        
        // Assuming you want to keep existing values for other properties,
        // you might want to load the existing filters first:
        if let existingFilters = loadFilters() {
            filters.regions = existingFilters.regions
            filters.origins = existingFilters.origins
            filters.gender = existingFilters.gender
            filters.size = existingFilters.size
        }
        
        let encodedFilters = try? JSONEncoder().encode(filters)
        UserDefaults.standard.set(encodedFilters, forKey: "Filters")
    }
    
    // Helper function to load existing filters
    func loadFilters() -> Filters? {
        guard let data = UserDefaults.standard.data(forKey: "Filters") else { return nil }
        return try? JSONDecoder().decode(Filters.self, from: data)
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
