//
//  CountryLibraryTest.swift
//  Prenom AfricainsTests
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import XCTest
@testable import Prenom_Africains

final class CountryLibraryTests: XCTestCase {

    func testCountries() {
        let france = Country(code: "FR")

        assert(france.code == france.id)

        assert(france.name == "France")
        assert(france.flag == "🇫🇷")

        assert(france.flagAndName == "🇫🇷 France")

        assert(CountryLibrary.countries.count > 250)
        assert(CountryLibrary.countries[0].name < CountryLibrary.countries[1].name)
        assert(CountryLibrary.countries[125].name < CountryLibrary.countries[126].name)
    }

    func testCountryExtensionStringByCode() {
        let string = "FR"
        let country = string.country(by: .code)
        assert(country?.name ?? "" == "France")

        let stringNotOk = ""
        let countryNotOk = stringNotOk.country(by: .code)
        assert(countryNotOk?.name ?? "" == "")
    }

    func testCountryExtensionStringByName() {
        let string = "fRaNce"
        let country = string.country(by: .name)
        assert(country?.name ?? "" == "France")

        let stringNotOk = ""
        let countryNotOk = stringNotOk.country(by: .name)
        assert(countryNotOk?.name ?? "" == "")
    }

    func testCountryExtensionArrayStringByCode() {
        let strings = ["Fr", "", "cA", "", "it"]
        let countries = strings.countries(by: .code)
        print(countries)
        assert(countries.count == 3)
        assert(countries[0].name == "France")
    }

}
