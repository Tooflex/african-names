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

    let realm = try? Realm()

    var body: some Scene {
        WindowGroup {

            ContentView()
                .environmentObject(FirstNameViewModel(realm: realm!))
                .environmentObject(SearchScreenViewModel())
        }
    }
}
