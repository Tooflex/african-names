//
//  FilterService.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 9/11/24.
//

import Foundation

class FilterService {
    private let filterKey = "Filters"
    
    // MARK: - Public Methods
    
    func saveFilters(_ filters: Filters) {
        let encodedFilters = try? JSONEncoder().encode(filters)
        UserDefaults.standard.set(encodedFilters, forKey: filterKey)
    }
    
    func loadFilters() -> Filters {
        guard let data = UserDefaults.standard.data(forKey: filterKey),
              let filters = try? JSONDecoder().decode(Filters.self, from: data) else {
            return Filters()
        }
        return filters
    }
    
    func clearFilters() {
        saveFilters(Filters())
    }
    
    func updateFilters(update: (inout Filters) -> Void) {
        var filters = loadFilters()
        update(&filters)
        saveFilters(filters)
    }
    
    func isAnyFilterApplied() -> Bool {
        let filters = loadFilters()
        return filters.isFavorite ||
               !filters.regions.isEmpty ||
               !filters.origins.isEmpty ||
               !filters.gender.isEmpty ||
               !filters.size.isEmpty ||
               filters.onTop != 0
    }
    
    func saveOnTopFirstname(_ firstnameId: Int) {
        updateFilters { filters in
            filters.onTop = firstnameId
        }
    }
    
    // MARK: - Helper Methods
    
    func filtersAsDictionary() -> [String: Any] {
        return loadFilters().asDictionary()
    }
}

struct Filters: Codable {
    var isFavorite: Bool = false
    var regions: [String] = []
    var origins: [String] = []
    var gender: [String] = []
    var size: [String] = []
    var onTop: Int = 0
    
    var isEmpty: Bool {
        !isFavorite && regions.isEmpty && origins.isEmpty && gender.isEmpty && size.isEmpty && onTop == 0
    }
    
    init() {}
    
    init(dict: [String: Any]) {
        isFavorite = dict["isFavorite"] as? Bool ?? false
        regions = dict["regions"] as? [String] ?? []
        origins = dict["origins"] as? [String] ?? []
        gender = dict["gender"] as? [String] ?? []
        size = dict["size"] as? [String] ?? []
        onTop = dict["onTop"] as? Int ?? 0
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "isFavorite": isFavorite,
            "regions": regions,
            "origins": origins,
            "gender": gender,
            "size": size,
            "onTop": onTop
        ]
    }
}
