//
//  DataRepository.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 03/09/2021.
//

import Foundation
import RealmSwift

protocol DataRepositoryProtocol {
    func fetchFirstnames(completion: @escaping ([FirstnameDataModel]) -> Void)
}

final class DataRepository: ObservableObject, DataRepositoryProtocol {

    private let realm: Realm

    private let apiService: FirstNameApiServiceProtocol

    public static let sharedInstance = DataRepository()

    init(apiService: FirstNameApiServiceProtocol = FirstNameApiService()) {
        // swiftlint:disable force_try
        realm = try! Realm()
        self.apiService = apiService
    }

    // MARK: CRUD Actions
    func add(firstname: FirstnameDataModel) {
        objectWillChange.send()
        do {
            let firstnameDB = FirstnameDB()
            firstnameDB.localId = UUID().hashValue
            firstnameDB.id = firstname.id ?? 0
            firstnameDB.firstname = firstname.firstname ?? ""
            firstnameDB.gender = firstname.gender.rawValue
            firstnameDB.meaning = firstname.meaning ?? ""
            firstnameDB.origins = firstname.origins ?? ""
            firstnameDB.firstnameSize = firstname.size?.rawValue ?? ""

            try realm.write {
                realm.add(firstnameDB)
            }
        } catch let error {
            // Handle error
            print(error)
        }
    }

    func addAll(firstnamesToAdd: [FirstnameDataModel]) {
        for firstname in firstnamesToAdd {
            add(firstname: firstname)
        }
    }

    func update(firstname: FirstnameDataModel) {
        objectWillChange.send()
        do {
            try realm.write {
                realm.create(
                    FirstnameDB.self,
                    value: [
                        "id": firstname.id ?? "",
                        "firstname": firstname.firstname ?? "",
                        "gender": firstname.gender,
                        "meaning": firstname.meaning ?? "",
                        "origins": firstname.origins ?? "",
                        "size": firstname.size ?? ""
                    ],
                    update: .modified)
            }
        } catch let error {
            // Handle error
            print(error)
        }
    }

    func deleteAll() {

        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            // handle error
            print(error)
        }

    }

    func fetchLocalData<T: Object>(type: T.Type, filter: String? = "") -> Results<T> {
        let results: Results<T>
        if let filter = filter {
            if !filter.isEmpty {
                results = realm.objects(type).filter(filter)
            } else {
                results = realm.objects(type)
            }
        } else {
            results = realm.objects(type)
        }
        return results
    }

    /// TODO: Catch 'Invalid property name' exception
    func fetchLocalData<T: Object>(type: T.Type, filter: NSPredicate) throws -> Results<T> {
        let results: Results<T>

        results = realm.objects(type).filter(filter)

        return results
    }

    func fetchFirstnames(completion: @escaping ([FirstnameDataModel]) -> Void) {
        apiService.fetchFirstnames { firstnames in

            self.deleteAll() // TODO: Update instead of delete in order to keep favorites
            self.addAll(firstnamesToAdd: firstnames)
            completion(firstnames)
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDataModel) {
        objectWillChange.send()
        do {
            let favorite = firstnameObj.isFavorite
            if let firstnameId = firstnameObj.id {
                try realm.write {
                    realm.create(
                        FirstnameDB.self,
                        value: ["id": firstnameId, "isFavorite": !(favorite)],
                        update: .modified)
                }
            }
        } catch let error {
            // Handle error
            print(error)
        }
    }

    func toggleFavorited(firstnameObj: FirstnameDB) {
        objectWillChange.send()
        do {
            let favorite = firstnameObj.isFavorite

            try realm.write {
                realm.create(
                    FirstnameDB.self,
                    value: ["localId": firstnameObj.localId, "isFavorite": !(favorite)],
                    update: .modified)
            }

        } catch let error {
            // Handle error
            print(error)
        }
    }

}
