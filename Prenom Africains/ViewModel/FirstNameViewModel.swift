//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class FirstNameViewModel: ObservableObject {
    private let service: FirstNameService
    private let filterService: FilterService
    
    @Published var favoritedFirstnames: [FirstnameDB] = []
    @Published var firstnames: [FirstnameDB] = []
    @Published var isLoading = false
    @Published var isFiltered = false
    @Published var noResults = false
    @Published var noData = false
    @Published var currentFirstname: FirstnameDB?
    @Published var firstnameOnTop: FirstnameDB?
    @Published var isCurrentFavorite = false
    
    @Published var adFrequency: Int
    private var showAdCounter = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: FirstNameService) {
        self.service = service
        self.filterService = FilterService()
        self.adFrequency = RemoteConfigManager.value(forKey: RemoteConfigKeys.adFrequency) as? Int ?? 10
        
        Task { await loadFirstnames() }
        
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task { await self?.loadFirstnames() }
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        Task {
            await loadFirstnames()
            if !isFiltered {
                await fetchOnline()
            }
        }
    }
    
    func loadFirstnames() async {
        favoritedFirstnames = service.getLocalFirstnames(filter: "isFavorite = true")
        
        if !filterService.isAnyFilterApplied() {
            isFiltered = false
            firstnames = service.getLocalFirstnames().shuffled()
        } else {
            isFiltered = true
            firstnames = service.filterFirstnames(filters: filterService.filtersAsDictionary()).shuffled()
            
            let filters = filterService.loadFilters()
            if filters.onTop != 0 {
                firstnameOnTop = firstnames.first { $0.id == filters.onTop }
            }
        }
        
        if let first = firstnames.first {
            currentFirstname = first
            noResults = false
        } else {
            noResults = true
        }
        
        noData = firstnames.isEmpty
        
        if let onTop = firstnameOnTop, let index = firstnames.firstIndex(where: { $0.id == onTop.id }) {
            firstnames.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        }
    }
    
    func toggleFavorited(firstname: FirstnameDB) async {
        try? await service.toggleFavorited(firstname: firstname)
        isCurrentFavorite = firstname.isFavorite
    }
    
    func fetchOnline() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            _ = try await service.fetchFirstnames(page: 0, size: 1000)
            await loadFirstnames()
            isLoading = false
        } catch {
            print("Error fetching firstnames: \(error)")
            isLoading = false
        }
    }
    
    func incrementShowAdCounter(_ adViewModel: AdsViewModel) {
        showAdCounter += 1
        if showAdCounter >= adFrequency {
            showAdCounter = 0
            adViewModel.showInterstitial.toggle()
        }
    }
    
    func clearFilters() {
        filterService.clearFilters()
        isFiltered = false
        Task { await loadFirstnames() }
    }
    
    func updateFilters(_ update: @escaping (inout Filters) -> Void) {
        filterService.updateFilters(update: update)
        Task { await loadFirstnames() }
    }
    
    func setFirstnameOnTop(_ firstname: FirstnameDB) {
        filterService.saveOnTopFirstname(firstname.id)
        Task { await loadFirstnames() }
    }
    
    func searchFirstnames(searchString: String) async {
        do {
            let searchResults = try await service.searchFirstnames(searchString: searchString, page: 0, size: 1000)
            firstnames = searchResults.map { FirstnameDB(from: $0) }
            noResults = firstnames.isEmpty
        } catch {
            print("Error searching firstnames: \(error)")
        }
    }
}

extension FirstnameDataModel {
    init(from db: FirstnameDB) {
        self.id = db.id
        self.firstname = db.firstname
        self.gender = Gender(rawValue: db.gender) ?? .undefined
        self.meaning = db.meaning
        self.meaningMore = db.meaningMore
        self.origins = db.origins
        self.size = Size(rawValue: db.firstnameSize)
        self.regions = db.regions
        self.soundURL = db.soundURL
        self.isFavorite = db.isFavorite
    }
}

extension FirstnameDB {
    func getDisplayMeaning(deviceLanguage: String) -> String {
        if deviceLanguage == "fr" {
            return meaning
        } else {
            // Find the translation for the current language
            let translation = translations.first { $0.languageCode == deviceLanguage }
            print("Translation: \(translation?.meaningTranslation ?? "")")
            return translation?.meaningTranslation ?? meaning // Fallback to French meaning if no translation
        }
    }
    
    // Helper method to get translation for a specific language
    func getTranslation(for languageCode: String) -> FirstnameTranslationDB? {
        return translations.first { $0.languageCode == languageCode }
    }
}

// Add convenience init to convert from data model
extension FirstnameDB {
    convenience init(from model: FirstnameDataModel) {
        self.init()
        
        self.id = model.id ?? 0
        self.firstname = model.firstname ?? ""
        self.gender = model.gender.rawValue
        self.isFavorite = model.isFavorite
        self.meaning = model.meaning ?? ""
        self.meaningMore = model.meaningMore ?? ""
        self.origins = model.origins ?? ""
        self.soundURL = model.soundURL ?? ""
        self.regions = model.regions ?? ""
        self.firstnameSize = model.size?.rawValue ?? ""
        
        // Handle translations
        if let modelTranslations = model.translations {
            for modelTranslation in modelTranslations {
                let translationDB = FirstnameTranslationDB()
                translationDB.meaningTranslation = modelTranslation.meaningTranslation ?? ""
                translationDB.originsTranslation = modelTranslation.originsTranslation ?? ""
                // Note: You'll need to set the languageCode based on your data structure
                translationDB.languageCode = "en" // Set appropriate language code
                translations.append(translationDB)
            }
        }
    }
}
