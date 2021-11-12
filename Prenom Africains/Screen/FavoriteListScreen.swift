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

    @StateObject fileprivate var viewModel = FavoriteListViewModel()
    var body: some View {
        VStack {
            if let favorites = viewModel.favoritedFirstnamesResults {
                if favorites.isEmpty {
                    Spacer()
                    LottieView(name: "noresults", loopMode: .playOnce)
                        .frame(width: 54 * sizeMultiplier(), height: 54 * sizeMultiplier())
                    Text("No favorite firstname")
                    Spacer()
                } else {
                    List(favorites) { firstname in
                        Text("\(firstname.firstname)")
                    }.foregroundColor(.offWhite)        .listRowBackground(Color.primary.colorInvert())
                }
            }
        }
    }

    func sizeMultiplier() -> CGFloat {
        if vSizeClass == .regular && hSizeClass == .regular { // Compact width, regular height
            return 2
        } else {
            return 1
        }
    }
}
