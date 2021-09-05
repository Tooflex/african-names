//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import RealmSwift

final class FirstNameViewModel: ObservableObject {

    let realm = DataRepository.sharedInstance

    @Published var favoritedFirstnamesResults: Results<FirstnameDB>?
    @Published var firstnamesResults: Results<FirstnameDB>?
    var firstnamesToken: NotificationToken?
    @Published var loaded = false
    @Published var isLoading = false
    @Published var currentFirstname: FirstnameDB = FirstnameDB()

    var tokens: Set<AnyCancellable> = []

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    private var task: AnyCancellable?

    let username = "user"
    let password = "Manjack76"

    init() {
        self.favoritedFirstnamesResults = realm.fetchData(type: FirstnameDB.self, filter: "isFavorite = true")
        self.firstnamesResults = realm.fetchData(type: FirstnameDB.self)
        // self.firstnames = self.firstnamesResults.map(FirstnameDataModel.init)
        self.currentFirstname = self.firstnamesResults?.first ?? FirstnameDB()
        fetchFirstnames()
    }

    deinit {
        self.firstnamesToken?.invalidate()
    }

    func fetchFirstnames() {

        loaded = true

        if let apiEndpoint = apiEndpoint {

        let url = "\(apiEndpoint)/api/v1/firstnames/random"

        let headers: HTTPHeaders = [.authorization(username: username, password: password)]

        AF.request(url, headers: headers)
            .validate()
            .publishDecodable(type: [FirstnameDataModel].self)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { (response) in
                switch response.result {
                case .success(let model):
                        self.realm.addAll(firstnamesToAdd: model)
                        self.currentFirstname = self.firstnamesResults?.shuffled().first ?? FirstnameDB()
                    self.activateFirstnamesToken()
                    self.loaded = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).store(in: &tokens)
        } else {
            return
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDataModel) {
        objectWillChange.send()
        do {
            let favorite = firstnameObj.isFavorite
            if let firstnameId = firstnameObj.id {
                let realm = try Realm()
                try realm.write {
                    realm.create(
                        FirstnameDB.self,
                        value: ["id": firstnameId, "isFavorite": !(favorite)],
                        update: .modified)
                }
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDB) {
        objectWillChange.send()
        do {
            let favorite = firstnameObj.isFavorite

                let realm = try Realm()
                try realm.write {
                    realm.create(
                        FirstnameDB.self,
                        value: ["id": firstnameObj.id, "isFavorite": !(favorite)],
                        update: .modified)
                }

        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    func update(
        firstnameID: Int,
        firstname: String,
        gender: String,
        meaning: String,
        origins: String
    ) {
        objectWillChange.send()
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(
                    FirstnameDB.self,
                    value: [
                        "id": firstnameID,
                        "firstname": firstname,
                        "gender": gender,
                        "meaning": meaning,
                        "origins": origins
                    ],
                    update: .modified)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    private func activateFirstnamesToken() {
        do {
            let firstnames = self.realm.fetchData(type: FirstnameDB.self)
            self.firstnamesToken = firstnames.observe { _ in
                // When there is a change, replace the old firstnames array with a new one.
                self.firstnamesResults = self.realm.fetchData(type: FirstnameDB.self)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

}
