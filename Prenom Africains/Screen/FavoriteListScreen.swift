//
//  FavoriteListScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import SwiftUI
import L10n_swift

struct FavoriteListScreen: View {

    @Environment(\.colorScheme) var currentMode

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @Binding var selectedTab: Int

    @StateObject fileprivate var viewModel = FavoriteListViewModel()

    var body: some View {

        VStack {
            Group {
                Spacer()
                Text("My List".l10n())
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            if let favorites = viewModel.favoritedFirstnamesResults {
                if favorites.isEmpty {
                    VStack {
                        Spacer()

                        LottieView(name: "noresults", loopMode: .playOnce)
                            .frame(
                                width: 54 * sizeMultiplier(vSizeClass, hSizeClass),
                                height: 54 * sizeMultiplier(vSizeClass, hSizeClass))
                        Text("No favorite firstname".l10n())

                        Spacer()
                    }

                } else {
                    Spacer()
                    List {
                        ForEach(favorites) { firstname in
                        Button(action: {
                            viewModel.selectedFirstname = firstname
                            viewModel.saveFilters()
                            self.selectedTab = 0 // Go back to Home screen
                        }, label: {
                            if firstname.gender == Gender.male.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color("blue"))
                            } else if firstname.gender == Gender.female.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color("pink"))
                            } else if firstname.gender == Gender.mixed.rawValue {
                                Text("\(firstname.firstname)").foregroundColor(Color("purple"))
                            } else {
                                Text("\(firstname.firstname)").foregroundColor(Color("black"))
                            }
                        }).padding(10)
                                .swipeActions {
                            Button {
                                self.viewModel.removeFromList(firstname: firstname)
                            } label: {
                                Label("Delete".l10n(), systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        }

                    }
                    .background(.regularMaterial)
                    Spacer()
                }
            }

        }
    }
}
