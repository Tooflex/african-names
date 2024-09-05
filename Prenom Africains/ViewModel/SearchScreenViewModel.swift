//
//  SearchScreenViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import Foundation
import Combine
import SwiftUI
import L10n_swift

@MainActor
final class SearchScreenViewModel: ObservableObject {
    private let service: FirstNameService
    
    @Published var searchResults: [FirstnameDB] = []
    @Published var loading = false
    @Published var sizes: [ChipsDataModel] = []
    @Published var areas: [ChipsDataModel] = []
    @Published var origins: [ChipsDataModel] = []
    @Published var currentFilterChain = ""
    @Published var filters = Filters()
    @Published var selectedFirstnameInSearchResults: FirstnameDB?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: FirstNameService) {
        self.service = service
        initializeChips()
        loadFilters()
        
        $filters
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.saveFilters() }
            .store(in: &cancellables)
    }
    
    func searchFirstnames(searchString: String) async {
        guard !searchString.isEmpty else {
            await MainActor.run {
                searchResults = []
            }
            return
        }
        
        await MainActor.run {
            loading = true
        }
        
        do {
            let results = try await service.searchFirstnames(searchString: searchString, filters: filters)
            await MainActor.run {
                searchResults = results
                loading = false
            }
        } catch {
            print("Search error: \(error)")
            await MainActor.run {
                loading = false
            }
        }
    }
    
    func goToChosenFirstname() {
        guard let selectedFirstname = selectedFirstnameInSearchResults else { return }
        UserDefaults.standard.set(["onTop": selectedFirstname.id], forKey: "Filters")
    }
    
    func filterIsFavorite(_ isFavorite: Bool) {
        filters.isFavorite = isFavorite
        updateChipsSelection()
    }
    
    func toggleGender(_ gender: String) {
        if filters.gender.contains(gender) {
            filters.gender.removeAll { $0 == gender }
        } else {
            filters.gender.append(gender)
        }
        updateChipsSelection()
    }
    
    private func initializeChips() {
        sizes = service.fetchSizes().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n(resource: "en").l10n()) }
        areas = service.fetchAreas().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n()) }
        origins = service.fetchOrigins().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n()) }
    }
    
    private func loadFilters() {
        if let savedFilters = UserDefaults.standard.object(forKey: "Filters") as? [String: Any] {
            filters = Filters(dict: savedFilters)
            updateChipsSelection()
        }
    }
    
    func saveFilters() {
        UserDefaults.standard.set(filters.asDictionary(), forKey: "Filters")
    }
    
    private func updateChipsSelection() {
        sizes.forEach { $0.isSelected = filters.size.contains($0.titleKey.capitalized) }
        areas.forEach { $0.isSelected = filters.regions.contains($0.titleKey.capitalized) }
        origins.forEach { $0.isSelected = filters.origins.contains($0.titleKey.capitalized) }
    }
    
}

struct Filters: Codable {
    var isFavorite: Bool = false
    var regions: [String] = []
    var origins: [String] = []
    var gender: [String] = []
    var size: [String] = []
    
    init() {}
    
    init(dict: [String: Any]) {
        isFavorite = dict["isFavorite"] as? Bool ?? false
        regions = dict["regions"] as? [String] ?? []
        origins = dict["origins"] as? [String] ?? []
        gender = dict["gender"] as? [String] ?? []
        size = dict["size"] as? [String] ?? []
    }
    
    func asDictionary() -> [String: Any] {
        return [
            "isFavorite": isFavorite,
            "regions": regions,
            "origins": origins,
            "gender": gender,
            "size": size
        ]
    }
}
