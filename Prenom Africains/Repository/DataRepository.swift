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

            self.deleteAll()
            self.addAll(firstnamesToAdd: firstnames)
            completion(firstnames)
        }
    }
}
