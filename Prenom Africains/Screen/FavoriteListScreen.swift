//
//  FavoriteListScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import SwiftUI

struct FavoriteListScreen: View {

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @Binding var selectedTab: Int

    @StateObject fileprivate var viewModel = FavoriteListViewModel()

    var body: some View {
        VStack {
            if let favorites = viewModel.favoritedFirstnamesResults {
                if favorites.isEmpty {
                    Spacer()
                    LottieView(name: "noresults", loopMode: .playOnce)
                        .frame(
                            width: 54 * sizeMultiplier(vSizeClass, hSizeClass),
                            height: 54 * sizeMultiplier(vSizeClass, hSizeClass))
                    Text("No favorite firstname")
                    Spacer()
                } else {
                    List(favorites) { firstname in
                        Button(action: {
                            viewModel.selectedFirstname = firstname
                            viewModel.saveFilters()
                            self.selectedTab = 0 // Go back to Home screen
                        }, label: {
                            if firstname.gender == Gender.male.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color.appBlue)
                            } else if firstname.gender == Gender.female.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color.pink)
                            } else if firstname.gender == Gender.mixed.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color.purple)
                            } else {
                                Text("\(firstname.firstname)").foregroundColor(Color.black)
                            }
                        })
                    }
                }
            }
        }
    }
}
