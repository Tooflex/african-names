//
//  ContentView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State var selectedTab = 0
    @State var searchString = NSCompoundPredicate()

    let tabHome = 0
    let tabSearch = 1
    let tabMyList = 2
    let tabShare = 3
    let tabParams = 4

    var body: some View {
        ZStack {
            Color.offWhite
        VStack {
            switch selectedTab {
            case 0:
                    MainScreen(searchString: $searchString)
            case 1:
                    SearchScreen(selectedTab: $selectedTab, searchString: $searchString)
            case 2:
                    FavoriteListScreen(selectedTab: $selectedTab)
            default :
                    MainScreen(searchString: $searchString)
            }
            MenuView(selectedTab: $selectedTab)
            Spacer()
        }.padding(.vertical)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            Group {
       ContentView()
                    .previewDevice("iPhone 12")
                    .previewDisplayName("iPhone 12")

                ContentView()
                    .previewDevice("iPhone 8")
                    .previewDisplayName("iPhone 8")
            }.preferredColorScheme($0)
        }

    }
}
