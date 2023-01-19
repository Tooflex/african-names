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
    func fetchFirstnames(completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void)

	func fetchFirstnames(numberOfElements: Int, completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void)

	func fetchLocalData<T: Object>(type: T.Type, filter: NSPredicate) throws -> Results<T>
	func fetchLocalData<T: Object>(type: T.Type, filter: String?) -> Results<T>
	func searchFirstname(
		searchString: String,
		completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void)
	func toggleFavorited(firstnameObj: FirstnameDataModel)
	func toggleFavorited(firstnameObj: FirstnameDB)
	func count() -> Int
}

final class DataRepository: ObservableObject, DataRepositoryProtocol {

    private let realm: Realm

    private let apiService: FirstNameApiServiceProtocol

    public static let sharedInstance = DataRepository()

    init(apiService: FirstNameApiServiceProtocol = FirstNameApiService()) {

		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 1,

			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in

				if oldSchemaVersion < 1 {
					// Add your class name where you have added new property 'tranport'.
					migration.enumerateObjects(ofType: FirstnameDB.className()) { _, newObject in
						newObject?["meaningMore"] = ""
					}
				}
			}
		)
		Realm.Configuration.defaultConfiguration = config

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
		firstnameDB.meaningMore = firstname.meaningMore ?? ""
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

            if let firstnameAlreadyExisting = realm.object(ofType: FirstnameDB.self, forPrimaryKey: firstname.id) {
                // update - keep favorite state
                firstnameDB.isFavorite = firstnameAlreadyExisting.isFavorite
            }

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

    func fetchFirstnames(completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void) {
        apiService.fetchFirstnames { result in

			if let firstnameResponse = result.value {
				if let firstnames = firstnameResponse.content {
					self.addAll(firstnamesToAdd: firstnames)
				}
            }

            completion(result)
        }
    }

	func fetchFirstnames(numberOfElements: Int, completion: @escaping (Alamofire.DataResponse<FirstnameResponse, Alamofire.AFError>) -> Void) {
		apiService.fetchFirstnames(numberOfElements: numberOfElements) { result in
			if let firstnameResponse = result.value {
				if let firstnames = firstnameResponse.content {
					self.addAll(firstnamesToAdd: firstnames)
				}
			}

			completion(result)
		}
	}

    func searchFirstname(
        searchString: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        apiService.searchFirstnamesRemote(searchString: searchString, completion: completion)
    }

    func filterFirstnamesRemote(
        filterChain: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
            apiService.filterFirstnamesRemote(filterChain: filterChain, completion: completion)
        }

    func fetchOrigins(completion: @escaping (DataResponse<[String], AFError>) -> Void) {
        apiService.fetchOrigins(completion: completion)
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

	func count() -> Int {
		return realm.objects(FirstnameDB.self).count
	}

}
