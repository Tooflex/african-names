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
    
    @Published var favoritedFirstnames: [FirstnameDB] = []
    @Published var firstnames: [FirstnameDB] = []
    @Published var isLoading = false
    @Published var isFiltered = false
    @Published var noResults = false
    @Published var noData = false
    @Published var currentFirstname: FirstnameDB?
    @Published var firstnameOnTop: FirstnameDB?
    
    @Published var adFrequency: Int
    private var showAdCounter = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: FirstNameService) {
        self.service = service
        self.adFrequency = RemoteConfigManager.value(forKey: RemoteConfigKeys.adFrequency) as? Int ?? 10
        
        loadFirstnames()
        
        // Observe changes in UserDefaults for filters
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.loadFirstnames()
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        loadFirstnames()
        if !isFiltered {
            fetchOnline()
        }
    }
    
    func loadFirstnames() {
        let filters = UserDefaults.standard.object(forKey: "Filters") as? [String: Any] ?? [:]
        
        Task {
            favoritedFirstnames = service.getLocalFirstnames(filter: "isFavorite = true")
        }
        
        if filters.isEmpty {
            Task {
                isFiltered = false
                firstnames = service.getLocalFirstnames().shuffled()
            }
        } else {
            isFiltered = true
            firstnames = service.filterFirstnames(filters: filters).shuffled()
            
            if let filterOnTop = filters["onTop"] as? Int, filterOnTop != -1 {
                firstnameOnTop = firstnames.first { $0.id == filterOnTop }
            }
        }
        
        if let first = firstnames.first {
            currentFirstname = first
            noResults = false
        } else {
            Task {
                noResults = true
            }
        }
        
        Task {
            noData = firstnames.isEmpty
        }
        // Move firstnameOnTop to the top of the list if it exists
        if let onTop = firstnameOnTop, let index = firstnames.firstIndex(where: { $0.id == onTop.id }) {
            firstnames.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        }
    }
    
    func toggleFavorited(firstname: FirstnameDB) async {
        try? await service.toggleFavorited(firstname: firstname)
        loadFirstnames()
    }
    
    func fetchOnline() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                _ = try await service.fetchFirstnames(page: 0, size: 1000)
                DispatchQueue.main.async {
                    self.loadFirstnames()
                    self.isLoading = false
                }
            } catch {
                print("Error fetching firstnames: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
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
        UserDefaults.standard.removeObject(forKey: "Filters")
        isFiltered = false
        loadFirstnames()
    }
    
    func searchFirstnames(searchString: String) {
        Task {
            do {
                let searchResults = try await service.searchFirstnames(searchString: searchString, page: 0, size: 1000)
                DispatchQueue.main.async {
                    self.firstnames = searchResults.map { FirstnameDB(from: $0) }
                    self.noResults = self.firstnames.isEmpty
                }
            } catch {
                print("Error searching firstnames: \(error)")
            }
        }
    }
}

extension FirstnameDB {
    convenience init(from model: FirstnameDataModel) {
        self.init()
        self.id = model.id ?? 0
        self.firstname = model.firstname ?? ""
        self.gender = model.gender.rawValue
        self.meaning = model.meaning ?? ""
        self.meaningMore = model.meaningMore ?? ""
        self.origins = model.origins ?? ""
        self.firstnameSize = model.size?.rawValue ?? ""
        self.regions = model.regions ?? ""
        self.soundURL = model.soundURL ?? ""
        self.isFavorite = model.isFavorite
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
