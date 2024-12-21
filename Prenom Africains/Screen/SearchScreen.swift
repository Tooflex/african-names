//
//  SearchScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI
import SlideOverCard
import L10n_swift
import Firebase
import FirebaseAnalytics

struct SearchScreen: View {
    @Binding var selectedTab: Tab
    @Binding var searchString: NSCompoundPredicate

    @StateObject var viewModel: SearchScreenViewModel

    @State private var resultArray: [FirstnameDB] = []
    @State private var isShowingResults = false
    @State private var searchText = ""

    var body: some View {
        ZStack {
            VStack {
                // MARK: Search Bar
                Group {
                    Spacer()
                    Text("Search".l10n())
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    SearchBarButton(showingSheet: $isShowingResults)
                        .padding(.horizontal)
                }
                Divider()
                    .background(Color("gray"))
                    .padding(.top, 10)
                
                // MARK: - Filters Options
                VStack {
                    Toggle("Only show favorites".l10n(), isOn: $viewModel.filters.isFavorite)
                        .padding()
                    
                    ChipsOptionView(
                        title: "Area".l10n(),
                        data: viewModel.areas,
                        action: { chipView in
                            if chipView.chip.isSelected {
                                let _ = print("Selected \(chipView.chip.titleKey)")
                                viewModel.filters.regions.append(chipView.chip.titleKey.capitalized)
                            } else {
                                let _ = print("Removed \(chipView.chip.titleKey)")
                                viewModel.filters.regions.removeAll { $0 == chipView.chip.titleKey.capitalized }
                            }
                        })
                    
                    Text("Gender".l10n())
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    
                    HStack {
                        GenderToggleButton(isSelected: viewModel.filters.gender.contains("female"),
                                           name: "md-female-select",
                                           action: { viewModel.toggleGender("female") })
                        
                        GenderToggleButton(isSelected: viewModel.filters.gender.contains("male"),
                                           name: "md-male-select",
                                           action: { viewModel.toggleGender("male") })
                    }
                    
                    ChipsOptionView(
                        title: "Size".l10n(),
                        data: viewModel.sizes,
                        action: { chipView in
                            if chipView.chip.isSelected {
                                let _ = print("Selected \(chipView.chip.titleKey)")
                                viewModel.filters.size.append(chipView.chip.titleKey)
                            } else {
                                let _ = print("Removed \(chipView.chip.titleKey)")
                                viewModel.filters.size.removeAll { $0 == chipView.chip.titleKey }
                            }
                        })
                }
                
                // MARK: Filter Submit Button
                Group {
                    Button(action: {
                        self.selectedTab = .home // Go back to Home screen
                    }) {
                        HStack {
                            Text("Filter".l10n())
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
                Analytics.logEvent(AnalyticsEventSearch, parameters: [
                    AnalyticsParameterSearchTerm: searchText as NSObject
                ])
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
                            ForEach(resultArray, id: \.self) { firstname in
                                Button {
                                    viewModel.selectedFirstnameInSearchResults = firstname
                                    viewModel.goToChosenFirstname()
                                    self.selectedTab = Tab.home // Go back to Home screen
                                } label: {
                                    NavigationLink(destination: Text(firstname.firstname)) {
                                        Text(firstname.firstname)
                                    }
                                }
                            }
                        }
                        .searchable(text: $searchText)
                        .navigationTitle("Firstnames")
                        .resignKeyboardOnDragGesture()
                    }.frame(alignment: .center)
                }
            }
        }
        .onAppear {
            viewModel.loadFilters()
        }
        .task {
            await viewModel.searchFirstnames(searchString: searchText)
        }
        .onChange(of: searchText) { newValue in
            Task {
                await viewModel.searchFirstnames(searchString: newValue)
            }
        }
    }
}

struct GenderToggleButton: View {
    let isSelected: Bool
    let name: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            LottieView(
                name: name,
                fromMarker: isSelected ? "touchDownStart" : "touchDownStart1",
                toMarker: isSelected ? "touchUpEnd" : "touchUpEnd1")
                .padding(.all, -30)
                .frame(width: 30, height: 30, alignment: .center)
        }
    }
}
