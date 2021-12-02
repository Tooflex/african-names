//
//  ParamScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI
import L10n_swift

struct ParamScreen: View {

    @Binding var selectedTab: Int

    @EnvironmentObject var paramViewModel: ParamViewModel

    var body: some View {
        VStack {
            Group {
                Spacer()
                Text("Params".l10n())
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Spacer()
            }
            VStack {
                Spacer()
                Text("Choose your language".l10n())
                Picker("Choose your language".l10n(), selection: $paramViewModel.languageCodeSelection) {
                    ForEach(paramViewModel.getLanguages()) { lang in
                        HStack {
                            Text(lang.name)
                        }
                    }
                }.onChange(of: paramViewModel.languageCodeSelection) { _ in
                    print("Lang changed to: \(String(describing: paramViewModel.languageCodeSelection))")
                    L10n.shared.language = paramViewModel.languageCodeSelection
                    selectedTab = 0
                }
                Spacer()
            }
        }
    }
}
