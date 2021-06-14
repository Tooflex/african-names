//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation
import Alamofire
import Combine
import RealmSwift

final class FirstNameViewModel: ObservableObject {

    private var favoritedFirstnamesResults: Results<FirstnameDB>
    private var firstnamesResults: Results<FirstnameDB>

    @Published var firstnames = [FirstnameDataModel]()
    @Published var favoritedFirstnames = [FirstnameDataModel]()
    @Published var loaded = false
    @Published var isLoading = false

    var tokens: Set<AnyCancellable> = []

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    private var task: AnyCancellable?

    let username = "user"
    let password = "Manjack76"

    init(realm: Realm) {
        favoritedFirstnamesResults = realm.objects(FirstnameDB.self)
            .filter("isFavorite = true")
        firstnamesResults = realm.objects(FirstnameDB.self)
        fetchFirstnames()
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
                    self.addAll(firstnamesToAdd: model)
                        self.firstnames = self.firstnamesResults.map(FirstnameDataModel.init)
                    self.loaded = false

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).store(in: &tokens)
        } else {
            return
        }
    }

    // MARK: CRUD Actions
    func add(id: Int, firstname: String, gender: String, meaning: String, origins: String) {
        objectWillChange.send()

        do {
            let realm = try Realm()

            let firstnameDB = FirstnameDB()
            firstnameDB.id = UUID().hashValue
            firstnameDB.firstname = firstname
            firstnameDB.gender = gender
            firstnameDB.meaning = meaning
            firstnameDB.origins = origins

            try realm.write {
                realm.add(firstnameDB)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    func addAll(firstnamesToAdd: [FirstnameDataModel]) {
        for firstname in firstnamesToAdd {
            add(id: firstname.id ?? 0,
                firstname: firstname.firstname ?? "",
                gender: firstname.gender.rawValue,
                meaning: firstname.meaning ?? "",
                origins: firstname.origins ?? "")
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDataModel) {
        objectWillChange.send()
        do {
            if let favorite = firstnameObj.isFavorite,
               let firstnameId = firstnameObj.id {
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
    
    func delete(firstnameID: Int) {
        // 1
        objectWillChange.send()
        // 2
        guard let firstnameDB = firstnamesResults.first(
            where: { $0.id == firstnameID })
        else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(firstnameDB)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

}
