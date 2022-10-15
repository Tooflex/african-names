//
//  ContentView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @Environment(\.colorScheme) var currentMode

	@EnvironmentObject var contentViewModel: ContentViewModel

    @State var searchString = NSCompoundPredicate()

    var body: some View {
        ZStack {
            currentMode == .dark ? Color.gray : Color.offWhite
        VStack {
			switch contentViewModel.selectedTab {
				case .home:
                    MainScreen()
				case .search:
                    SearchScreen(selectedTab: $contentViewModel.selectedTab, searchString: $searchString)
				case .list:
                    FavoriteListScreen(selectedTab: $contentViewModel.selectedTab)
				case .param:
                    ParamScreen(selectedTab: $contentViewModel.selectedTab)
            }
            MenuView(selectedTab: $contentViewModel.selectedTab)
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
                    .previewDisplayName("iPhone 12").environmentObject(FirstNameViewModel())

//                ContentView()
//                    .previewDevice("iPad Air (4th generation)")
//                    .previewDisplayName("iPad Air 4").environmentObject(FirstNameViewModel())
//
//                ContentView()
//                    .previewDevice("iPhone 8")
//                    .previewDisplayName("iPhone 8")
//                    .environmentObject(FirstNameViewModel())
            }.preferredColorScheme($0)
        }

    }
}
