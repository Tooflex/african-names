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
		languageCodeSelection = String(NSLocale.preferredLanguages.first?.prefix(2) ?? "en")
        print(languageCodeSelection)
    }

    func getLanguages() -> [Language] {
        let languages = CountryLibrary.languages.filter({ language in
            availableTranslations.contains(language.langId.lowercased().l10n())
        })
        return languages
    }

	func saveLastSelectedLanguage() {
		let defaults = UserDefaults.standard
		var lastLanguages = defaults.object(forKey: "LastSelectedLanguage") as? [String] ?? []
		print(lastLanguages)
		lastLanguages.append(languageCodeSelection)
		if lastLanguages.count > 2 {
			lastLanguages = lastLanguages.suffix(2)
			print(lastLanguages)
		}
		UserDefaults.standard.set(lastLanguages, forKey: "LastSelectedLanguage")
	}

}
