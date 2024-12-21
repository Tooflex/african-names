//
//  ContentViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 15/10/2022.
//

import SwiftUI
import L10n_swift

@MainActor
class ContentViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var currentFirstname: FirstnameDB
    @Published var isLanguageChanged: Bool
    @Published var searchString: NSCompoundPredicate
    @Published var isFirstLaunch: Bool
    
    private let service: FirstNameService
    private let filterService: FilterService

    init(service: FirstNameService, filterService: FilterService) {
        self.service = service
        self.filterService = filterService
        selectedTab = Tab.home
        currentFirstname = FirstnameDB()
        isLanguageChanged = false
        isFirstLaunch = true
        searchString = NSCompoundPredicate()
    }

    func checkDeepLink(url: URL) -> Bool {
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }

        print(host.queryItems ?? [])

        switch host.queryItems?.first?.name {
        case "tab":
            switch host.queryItems?.first?.value {
            case Tab.home.rawValue:
                selectedTab = .home
            case Tab.search.rawValue:
                selectedTab = .search
            case Tab.list.rawValue:
                selectedTab = .list
            case Tab.param.rawValue:
                selectedTab = .param
            default:
                return false
            }
        case "name":
            if let name = host.queryItems?.first?.value {
                return getFirstnameFromLink(name: name)
            } else {
                return false
            }
        default:
            return false
        }
        
        print(selectedTab.rawValue)
        return true
    }

    func getFirstnameFromLink(name: String) -> Bool {
        var firstnamesResults = Array(service.getLocalFirstnames().shuffled())

        if let firstnameToPutOnTop = firstnamesResults.first(where: { $0.firstname.lowercased() == name.lowercased() }) {
            firstnamesResults.move(firstnameToPutOnTop, to: 0)
            currentFirstname = firstnameToPutOnTop
            goToChosenFirstname()
            selectedTab = .home
            return true
        }

        return false
    }

    /**
     Add in User Defaults the id of the chosen firstname in search results
     */
    func goToChosenFirstname() {
        filterService.updateFilters { filters in
            filters.onTop = currentFirstname.id
        }
    }

    func saveFilters(selectedFirstname: FirstnameDB?) {
        filterService.updateFilters { filters in
            if let selectedFirstname = selectedFirstname {
                filters.isFavorite = true
                filters.onTop = selectedFirstname.id
            }
        }
    }
}

enum Tab: String {
	case home = "home"
	case search = "search"
	case list = "list"
	case param = "params"
}
