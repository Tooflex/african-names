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
    @Binding var selectedTab: Tab
    
    @EnvironmentObject private var viewModel: FavoriteListViewModel

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
            
            if viewModel.favoritedFirstnames.isEmpty {
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
                    ForEach(viewModel.favoritedFirstnames) { firstname in
                        Button(action: {
                            viewModel.selectedFirstname = firstname
                            viewModel.saveFilters()
                            selectedTab = .home // Go back to Home screen
                        }, label: {
                            Text("\(firstname.firstname)")
                                .foregroundColor(colorForGender(firstname.gender))
                        })
                        .padding(10)
                        .swipeActions {
                            Button {
                                Task {
                                    await viewModel.removeFromList(firstname: firstname)
                                }
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
        .task {
            await viewModel.loadFavorites()
        }
    }
    
    private func colorForGender(_ gender: String) -> Color {
        switch gender {
        case Gender.male.rawValue:
            return Color("blue")
        case Gender.female.rawValue:
            return Color("pink")
        case Gender.mixed.rawValue:
            return Color("purple")
        default:
            return Color("black")
        }
    }
}

//// Assuming this function is defined elsewhere in your project
//func sizeMultiplier(_ vSizeClass: UserInterfaceSizeClass?, _ hSizeClass: UserInterfaceSizeClass?) -> CGFloat {
//    // Implementation details
//    return 1.0 // Placeholder return value
//}
