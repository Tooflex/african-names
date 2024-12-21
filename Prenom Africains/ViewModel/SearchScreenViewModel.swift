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
    private let filterService: FilterService
    
    @Published var searchResults: [FirstnameDB] = []
    @Published var loading = false
    @Published var sizes: [ChipsDataModel] = []
    @Published var areas: [ChipsDataModel] = []
    @Published var origins: [ChipsDataModel] = []
    @Published var currentFilterChain = ""
    @Published var filters: Filters {
        didSet {
            updateChipsSelection()
        }
    }
    @Published var selectedFirstnameInSearchResults: FirstnameDB?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: FirstNameService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
        self.filters = filterService.loadFilters()
        
        initializeChips()
        
        // Observe filters changes and save them
        $filters
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] filters in
                self?.filterService.saveFilters(filters)
            }
            .store(in: &cancellables)
    }
    
    func searchFirstnames(searchString: String) async {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        
        loading = true
        
        do {
            let results = try await service.searchFirstnames(searchString: searchString, filters: filters)
            searchResults = results
            loading = false
        } catch {
            print("Search error: \(error)")
            loading = false
        }
    }
    
    func goToChosenFirstname() {
        guard let selectedFirstname = selectedFirstnameInSearchResults else { return }
        filterService.saveOnTopFirstname(selectedFirstname.id)
    }
    
    // MARK: - Filter Updates
    
    func updateFilter<T: Equatable>(_ keyPath: WritableKeyPath<Filters, [T]>, value: T) {
        filterService.updateFilters { filters in
            if filters[keyPath: keyPath].contains(value) {
                filters[keyPath: keyPath].removeAll { $0 == value }
            } else {
                filters[keyPath: keyPath].append(value)
            }
        }
        filters = filterService.loadFilters()
    }
    
    func filterIsFavorite(_ isFavorite: Bool) {
        filterService.updateFilters { filters in
            filters.isFavorite = isFavorite
        }
        filters = filterService.loadFilters()
    }
    
    func toggleGender(_ gender: String) {
        updateFilter(\.gender, value: gender)
    }
    
    func toggleSize(_ size: String) {
        updateFilter(\.size, value: size)
    }
    
    func toggleArea(_ area: String) {
        updateFilter(\.regions, value: area)
    }
    
    func toggleOrigin(_ origin: String) {
        updateFilter(\.origins, value: origin)
    }
    
    func clearFilters() {
        filterService.clearFilters()
        filters = filterService.loadFilters()
    }
    
    func loadFilters() {
        filters = filterService.loadFilters()
    }
    
    // MARK: - Private Methods
    
    private func initializeChips() {
        self.loadFilters()
        sizes = service.fetchSizes().map { size in
            print("Size: \(size)")
            sizes.forEach { print("Size filters: \($0.titleKey)") }
            return ChipsDataModel(
                isSelected: filters.size.contains(size),
                titleKey: size,
                displayedTitle: size.l10n()
            )
        }
        
        areas = service.fetchAreas().map { area in
            ChipsDataModel(
                isSelected: filters.regions.contains(area.capitalized),
                titleKey: area,
                displayedTitle: area.l10n()
            )
        }
        
        origins = service.fetchOrigins().map { origin in
            ChipsDataModel(
                isSelected: filters.origins.contains(origin.capitalized),
                titleKey: origin,
                displayedTitle: origin.l10n()
            )
        }
    }
    
    private func updateChipsSelection() {
        sizes.forEach { $0.isSelected = filters.size.contains($0.titleKey) }
        areas.forEach { $0.isSelected = filters.regions.contains($0.titleKey.capitalized) }
        origins.forEach { $0.isSelected = filters.origins.contains($0.titleKey.capitalized) }
    }
}

