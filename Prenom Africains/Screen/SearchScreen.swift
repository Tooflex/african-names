//
//  SearchScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI
import SlideOverCard

struct SearchScreen: View {
    @Binding var selectedTab: Int
    @Binding var searchString: NSCompoundPredicate

    @State private var isShowFavorite = false
    @EnvironmentObject var searchScreenViewModel: SearchScreenViewModel

    @State private var resultArray: [FirstnameDB] = []

    @State private var isResults = false
    @State private var isShowingResults = false

    @State private var searchText = ""

    var body: some View {
        ZStack {
            VStack {
                // MARK: Search Bar
                Group {
                Spacer()
                Text("Search")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    SearchBarButton(showingSheet: $isShowingResults)
                        .padding(.horizontal)
                }
                Divider().padding(.top, 10)
                // MARK: - Filters Options
                Group {
                    HStack {
                        Toggle("Only show favorites", isOn: $isShowFavorite).padding()
                    }
                    ChipsOptionView(
                                    title: "Area",
                                    data: searchScreenViewModel.areas)
                    Text("Gender")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    HStack {
                        if searchScreenViewModel.filterFemale {
                            Button(action: {
                                print("Female selected to unselected")
                                searchScreenViewModel.filterFemale = !searchScreenViewModel.filterFemale
                            }) {
                                LottieView(
                                    name: "md-female-select",
                                    fromMarker: "touchDownStart",
                                    toMarker: "touchUpEnd" )
                                    .padding(.all, -30)
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                        } else {
                            Button(action: {
                                print("Female unselected to selected")
                                searchScreenViewModel.filterFemale = !searchScreenViewModel.filterFemale
                            }) {
                                LottieView(
                                    name: "md-female-select",
                                    fromMarker: "touchDownStart1",
                                    toMarker: "touchUpEnd1")
                                    .padding(.all, -30)
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                        }

                        if searchScreenViewModel.filterMale {
                        Button(action: {
                            print("Male selected to unselected")
                            searchScreenViewModel.filterMale = !searchScreenViewModel.filterMale
                        }) {
                            LottieView(name: "md-male-select", fromMarker: "touchDownStart", toMarker: "touchUpEnd" )
                                .padding(.all, -30)
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                    } else {
                        Button(action: {
                            print("Male unselected to selected")
                            searchScreenViewModel.filterMale = !searchScreenViewModel.filterMale
                        }) {
                            LottieView(name: "md-male-select", fromMarker: "touchDownStart1", toMarker: "touchUpEnd1" )
                                .padding(.all, -30)
                                .frame(width: 30, height: 30, alignment: .center)
                        }
                    }
                    }
                    ChipsOptionView(
                        title: "Size",
                        data: searchScreenViewModel.sizes)
                }
                // MARK: Filter Submit Button
                Group {
                Button(action: {
                    // Update filters
                    searchScreenViewModel.filterIsFavorite = isShowFavorite
                    searchScreenViewModel.filterArea = searchScreenViewModel.areas.filter {
                        $0.isSelected }.map { $0.titleKey.capitalized }
                    searchScreenViewModel.filterGender = []
                    if searchScreenViewModel.filterMale {
                        searchScreenViewModel.filterGender.append("male")
                    }
                    if searchScreenViewModel.filterFemale {
                        searchScreenViewModel.filterGender.append("female")
                    }
                    searchScreenViewModel.filterSize = searchScreenViewModel.sizes.filter {
                        $0.isSelected }.map { $0.titleKey.lowercased() }
                    searchScreenViewModel.saveFilters()
                    self.selectedTab = 0 // Go back to Home screen
                }) {
                    HStack {
                        Text("Filter")
                            .fontWeight(.medium)
                            .font(.title2)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.appBlue)
                    .cornerRadius(10)
                }.padding()
                Spacer()
                }
            }
            // MARK: - SlideOver Search Results Card
            SlideOverCard(isPresented: $isShowingResults, onDismiss: {
                isShowingResults = false
                searchText = ""
            }) {
                // MARK: SlideOver Content
                Group {
                VStack {
                    SearchBarView(
                        searchText: $searchText,
                        resultArray: $resultArray,
                        showingSheet: $isShowingResults)
                    List {
                        // Filtered list of names
                        ForEach(resultArray, id: \.self) { prenom in
                            NavigationLink(destination: Text(prenom.firstname)) {
                                Text(prenom.firstname)
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .navigationTitle("Firstnames")
                    // .id(UUID())
                    .resignKeyboardOnDragGesture()
                }.frame(alignment: .center)
                }
            }
        }
        .onReceive(searchScreenViewModel.$searchResults) { firstnames in
                if !firstnames.isEmpty {
                    isResults = true
                } else {
                    isResults = false
                }
        }
    }
}

// struct SearchScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchScreen(selectedTab: .constant(0))
//    }
// }
