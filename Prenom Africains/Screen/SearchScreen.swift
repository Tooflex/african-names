//
//  SearchScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI
import SlideOverCard

struct SearchScreen: View {
    @State private var isShowFavorite = false
    @StateObject var searchScreenViewModel: SearchScreenViewModel

    @State private var resultArray: [FirstnameDataModel] = []

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
                // MARK: - Filters Options
                Group {
                    HStack {
                        Toggle("Only show favorites", isOn: $isShowFavorite).padding()
                    }
                    ChipsOptionView(searchScreenViewModel: searchScreenViewModel, title: "Area", data: searchScreenViewModel.areas)
                    ChipsOptionView(searchScreenViewModel: searchScreenViewModel, title: "Origins", data: searchScreenViewModel.origins)
                    Text("Gender")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    HStack {
                        Image("md-female")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                        Image("md-male").resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                    ChipsOptionView(searchScreenViewModel: searchScreenViewModel, title: "Size", data: searchScreenViewModel.sizes)
                }
                // MARK: Filter Submit Button
                Group {
                Button(action: {
                    print("Filter tapped!")
                    searchScreenViewModel.filterFirstnames()
                }) {
                    HStack {
                        Text("Filter")
                            .fontWeight(.medium)
                            .font(.title2)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.blue)
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
                    SearchBarView(searchScreenViewModel: searchScreenViewModel, searchText: $searchText, resultArray: $resultArray, showingSheet: $isShowingResults)
                    List {
                        // Filtered list of names
                        ForEach(resultArray, id: \.self) {
                            prenom in
                            // TODO: Replace for search item
                            Text(prenom.firstname ?? "")
                        }
                    }.id(UUID())
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

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        let searchScreenViewModel = SearchScreenViewModel()
        SearchScreen(searchScreenViewModel: searchScreenViewModel)
    }
}
