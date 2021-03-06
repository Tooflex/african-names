//
//  ParamViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 25/11/2021.
//

import Foundation

final class ParamViewModel: ObservableObject {

    @Published var languageCodeSelection: String
    private let availableTranslations = ["fr", "en", "it", "de"]

    init() {
        languageCodeSelection = NSLocale.preferredLanguages.first ?? "en"
        print(languageCodeSelection)
    }

    func getLanguages() -> [Language] {
        let languages = CountryLibrary.languages.filter({ language in
            availableTranslations.contains(language.langId.lowercased())
        })
        return languages
    }

}
