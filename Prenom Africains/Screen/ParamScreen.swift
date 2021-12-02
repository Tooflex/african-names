//
//  ParamScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI

struct ParamScreen: View {

    @Binding var selectedTab: Int

    @EnvironmentObject var paramViewModel: ParamViewModel

    var body: some View {
        VStack {
            Group {
                Spacer()
                Text("Params".localized())
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Spacer()
            }
            VStack {
                Spacer()
                Text("Choose your language".localized())
                Picker("Choose your language".localized(), selection: $paramViewModel.languageCodeSelection) {
                    ForEach(paramViewModel.getLanguages()) { lang in
                        HStack {
                            Text(lang.name)
                        }
                    }
                }.onChange(of: paramViewModel.languageCodeSelection) { _ in
                    print("Lang changed to: \(String(describing: paramViewModel.languageCodeSelection))")
                    Bundle.setLanguage(lang: paramViewModel.languageCodeSelection)
                    selectedTab = 0
                }
                Spacer()
            }
        }
    }
}
