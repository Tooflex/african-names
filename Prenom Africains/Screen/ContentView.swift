//
//  ContentView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @StateObject var firstNameViewModel = FirstNameViewModel()
    @StateObject var searchScreenViewModel = SearchScreenViewModel()
    @State var selectedTab = 0

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
                MainScreen(firstNameViewModel: firstNameViewModel)
            case 1:
                    SearchScreen(searchScreenViewModel: searchScreenViewModel)
            default :
                    MainScreen(firstNameViewModel: firstNameViewModel)
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
