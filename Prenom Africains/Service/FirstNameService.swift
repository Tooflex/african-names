//
//  FirstNameService.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 24/10/2021.
//

import Foundation
import Supabase

@MainActor
class FirstNameService {
    private let repository: FirstNameRepository
    
    init(repository: FirstNameRepository) {
        self.repository = repository
    }
    
    func fetchFirstnames(page: Int, size: Int) async throws -> [FirstnameDataModel] {
        let remoteFirstnames = try await repository.fetchRemoteData(page: page, size: size)
        
        // Save fetched data to local storage
        for firstname in remoteFirstnames {
            repository.saveData(firstname)
        }
        
        return remoteFirstnames
    }
    
    func getLocalFirstnames(filter: String? = nil) -> [FirstnameDB] {
        return Array(repository.fetchLocalData(type: FirstnameDB.self, filter: filter))
    }
    
    func searchFirstnames(searchString: String, page: Int, size: Int) async throws -> [FirstnameDataModel] {
        // Implement search logic using Supabase
        // For now, we'll just fetch all and filter locally
        let allFirstnames = try await fetchFirstnames(page: page, size: size)
        return allFirstnames.filter { $0.firstname?.lowercased().contains(searchString.lowercased()) ?? false }
    }
    
    func searchFirstnames(searchString: String, filters: Filters) async throws -> [FirstnameDB] {
        // First, fetch the firstnames that match the search string
        let searchResults = try await repository.searchFirstnames(searchString: searchString)
        
        // Then apply the filters
        return searchResults.filter { firstname in
            // Check if the firstname matches all the filters
            let matchesFavorite = !filters.isFavorite || firstname.isFavorite
            let matchesRegions = filters.regions.isEmpty || filters.regions.contains(firstname.regions)
            let matchesOrigins = filters.origins.isEmpty || filters.origins.contains(firstname.origins)
            let matchesGender = filters.gender.isEmpty || filters.gender.contains(firstname.gender)
            let matchesSize = filters.size.isEmpty || filters.size.contains(firstname.firstnameSize)
            
            return matchesFavorite && matchesRegions && matchesOrigins && matchesGender && matchesSize
        }
    }
    
    func filterFirstnames(filters: [String: Any]) -> [FirstnameDB] {
        let compoundPredicate = createFilterCompound(filterArray: filters)
        return Array(repository.fetchLocalData(type: FirstnameDB.self, filter: compoundPredicate))
    }
    
    func fetchOrigins() -> [String] {
        let allFirstnames = repository.fetchLocalData(type: FirstnameDB.self)
        return Array(Set(allFirstnames.compactMap { $0.origins }))
    }
    
    func fetchSizes() -> [String] {
        return ["short", "medium", "long"]
    }

    func fetchAreas() -> [String] {
        return ["northern africa", "eastern africa", "western africa", "southern africa"]
    }
    
//    func toggleFavorited(firstname: FirstnameDataModel) {
//        repository.toggleFavorited(firstnameObj: firstname)
//    }
    
    func getFavoritedFirstnames() async throws -> [FirstnameDB] {
        return try await repository.getFavoritedFirstnames()
    }
    
    func toggleFavorited(firstname: FirstnameDB) async throws {
        try await repository.toggleFavorited(firstname: firstname)
    }
    
    func count() -> Int {
        return repository.count()
    }
    
    private func createFilterCompound(filterArray: [String: Any]) -> NSCompoundPredicate {
        var subPredicates = [NSPredicate]()
        
        if let isFavorite = filterArray["isFavorite"] as? Bool {
            subPredicates.append(NSPredicate(format: "isFavorite == %d", isFavorite))
        }
        
        if let regions = filterArray["regions"] as? [String], !regions.isEmpty {
            subPredicates.append(NSPredicate(format: "regions IN %@", regions))
        }
        
        if let origins = filterArray["origins"] as? [String], !origins.isEmpty {
            subPredicates.append(NSPredicate(format: "origins IN %@", origins))
        }
        
        if let genders = filterArray["gender"] as? [String], !genders.isEmpty {
            subPredicates.append(NSPredicate(format: "gender IN %@", genders))
        }
        
        if let sizes = filterArray["size"] as? [String], !sizes.isEmpty {
            subPredicates.append(NSPredicate(format: "firstnameSize IN %@", sizes))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
    }
}
