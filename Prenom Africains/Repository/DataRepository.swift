//
//  DataRepository.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 03/09/2021.
//

import Foundation
import RealmSwift
import Alamofire

protocol DataRepositoryProtocol {
    func fetchFirstnames(completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void)
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
    fileprivate func convertFirstnameDataModelToFirstnameDB(_ firstname: FirstnameDataModel) -> FirstnameDB {
        let firstnameDB = FirstnameDB()
        firstnameDB.id = firstname.id ?? 0
        firstnameDB.firstname = firstname.firstname ?? ""
        firstnameDB.gender = firstname.gender.rawValue
        firstnameDB.meaning = firstname.meaning ?? ""
        firstnameDB.origins = firstname.origins ?? ""
        firstnameDB.firstnameSize = firstname.size?.rawValue ?? ""
        firstnameDB.regions = firstname.regions ?? ""
        firstnameDB.soundURL = firstname.soundURL ?? ""
        firstnameDB.isFavorite = firstname.isFavorite

        return firstnameDB
    }

    func add(firstname: FirstnameDataModel) {
        objectWillChange.send()
        do {
            let firstnameDB = convertFirstnameDataModelToFirstnameDB(firstname)

            try realm.write {
                realm.add(firstnameDB, update: Realm.UpdatePolicy.modified)
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
            let firstnameDB = convertFirstnameDataModelToFirstnameDB(firstname)
            try realm.write {
                realm.create(
                    FirstnameDB.self,
                    value: firstnameDB,
                    update: .modified)
            }
        } catch let error {
            // Handle error
            print(error)
        }
    }

    func update(firstname: FirstnameDB) {
        objectWillChange.send()
        do {
            try realm.write {
                realm.create(
                    FirstnameDB.self,
                    value: firstname,
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

    func updateAll(firstnamesToUpdate: [FirstnameDataModel]) {
        for firstname in firstnamesToUpdate {
            self.update(firstname: firstname)
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

    func fetchLocalData<T: Object>(type: T.Type, filter: NSPredicate) throws -> Results<T> {
        let results: Results<T>

        results = realm.objects(type).filter(filter)

        return results
    }

    func fetchFirstnames(completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        apiService.fetchFirstnames { result in

            if let firstnames = result.value {
                self.addAll(firstnamesToAdd: firstnames)
            }

            completion(result)
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
                    value: ["id": firstnameObj.id, "isFavorite": !(favorite)],
                    update: .modified)
            }

        } catch let error {
            // Handle error
            print(error)
        }
    }

}
