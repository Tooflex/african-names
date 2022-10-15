//
//  Prenom_AfricainsApp.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import RealmSwift

@main
struct PrenomAfricainsApp: App {
	@StateObject var contentViewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FirstNameViewModel())
                 .environmentObject(SearchScreenViewModel())
                 .environmentObject(ParamViewModel())
				 .environmentObject(contentViewModel)
				 .onOpenURL { url in
					 if contentViewModel.checkDeepLink(url: url) {
						 print("FROM DEEP LINK")
					 } else {
						 print("FALL BACK DEEP LINK")
					 }
				 }
        }
    }
}
