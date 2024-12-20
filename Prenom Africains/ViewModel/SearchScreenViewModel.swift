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
    @Published var filters: Filters
    @Published var selectedFirstnameInSearchResults: FirstnameDB?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: FirstNameService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
        self.filters = filterService.loadFilters()
        
        initializeChips()
        updateChipsSelection()
        
        $filters
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] filters in
                self?.filterService.saveFilters(filters)
            }
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
        if let selectedFirstname = selectedFirstnameInSearchResults {
            filterService.saveOnTopFirstname(selectedFirstname.id)
        }
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
    
    func toggleSize(_ size: String) {
        if filters.size.contains(size) {
            filters.size.removeAll { $0 == size }
        } else {
            filters.size.append(size)
        }
        updateChipsSelection()
    }
    
    func toggleArea(_ area: String) {
        if filters.regions.contains(area) {
            filters.regions.removeAll { $0 == area }
        } else {
            filters.regions.append(area)
        }
        updateChipsSelection()
    }
    
    func toggleOrigin(_ origin: String) {
        if filters.origins.contains(origin) {
            filters.origins.removeAll { $0 == origin }
        } else {
            filters.origins.append(origin)
        }
        updateChipsSelection()
    }
    
    private func initializeChips() {
        sizes = service.fetchSizes().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n(resource: "en").l10n()) }
        areas = service.fetchAreas().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n()) }
        origins = service.fetchOrigins().map { ChipsDataModel(isSelected: false, titleKey: $0, displayedTitle: $0.l10n()) }
    }
    
    private func updateChipsSelection() {
        sizes.forEach { $0.isSelected = filters.size.contains($0.titleKey.capitalized) }
        areas.forEach { $0.isSelected = filters.regions.contains($0.titleKey.capitalized) }
        origins.forEach { $0.isSelected = filters.origins.contains($0.titleKey.capitalized) }
    }
}

