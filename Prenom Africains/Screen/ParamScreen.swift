//
//  ParamScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI

struct ParamScreen: View {

    @Binding var selectedTab: Int
    @State var languageCodeSelection: String = "EN"

    var body: some View {
        VStack {
            Spacer()
            Text("Choose your language")
            Picker("Choose your language", selection: $languageCodeSelection) {
                ForEach(CountryLibrary.countries) { country in
                    HStack {
                        Text(country.code + " - " + country.flagAndName)
                    }
                }
            }
            Spacer()
        }
    }

}
