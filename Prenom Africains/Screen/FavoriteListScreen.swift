//
//  FavoriteListScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/11/2021.
//

import SwiftUI

struct FavoriteListScreen: View {

    @StateObject fileprivate var viewModel = FavoriteListViewModel()
    var body: some View {
        if let favorites = viewModel.favoritedFirstnamesResults {
            if favorites.isEmpty {
                Text("No results")
            } else {
                List(favorites) { firstname in
                    Text("\(firstname.firstname)")
                }.foregroundColor(.offWhite)        .listRowBackground(Color.primary.colorInvert())
            }
        }
    }
}
