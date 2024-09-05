//
//  DataRepository.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 03/09/2021.
//

import Foundation
import RealmSwift
import Supabase

@MainActor
class FirstNameRepository {
    private let client: SupabaseClient
    
    init() {
        // Initialize Realm
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: FirstnameDB.className()) { _, newObject in
                        newObject?["meaningMore"] = ""
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        
        // Initialize Supabase client
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://bsxgksdvjdaheemdwmhf.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzeGdrc2R2amRhaGVlbWR3bWhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg5OTc3ODYsImV4cCI6MjAzNDU3Mzc4Nn0.Rzq7k8kbxk2EynJp32PwqkHiklcZrU18WdwI6z_AAi8"
        )
    }
    
    func fetchLocalData<T: Object>(type: T.Type, filter: String? = nil) -> Results<T> {
        let realm = try! Realm()

        if let filter = filter, !filter.isEmpty {
            return realm.objects(type).filter(filter)
        } else {
            return realm.objects(type)
        }
    }
    
    func fetchLocalData<T: Object>(type: T.Type, filter: NSPredicate) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(type).filter(filter)
    }
    
    func fetchRemoteData(page: Int, size: Int) async throws -> [FirstnameDataModel] {
        let realm = try! Realm()

        let from = page * size
        let to = from + size - 1
        
        let query = client
            .from("firstname")
            .select("*", head: false, count: .exact)
            .order("firstname")
            .range(from: from, to: to)
        
        return try await query.execute().value
    }
    
    func saveData(_ firstname: FirstnameDataModel) {
        let realm = try! Realm()

        let firstnameDB = convertToFirstnameDB(firstname)
        do {
            try realm.write {
                realm.add(firstnameDB, update: .modified)
            }
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func updateData(_ firstname: FirstnameDataModel) {
        let realm = try! Realm()

        let firstnameDB = convertToFirstnameDB(firstname)
        do {
            try realm.write {
                realm.add(firstnameDB, update: .modified)
            }
        } catch {
            print("Error updating data: \(error)")
        }
    }
    
    func deleteAllData() {
        let realm = try! Realm()

        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting all data: \(error)")
        }
    }
    
    func toggleFavorited(firstnameObj: FirstnameDataModel) {
        let realm = try! Realm()

        guard let id = firstnameObj.id else { return }
        do {
            try realm.write {
                if let firstnameDB = realm.object(ofType: FirstnameDB.self, forPrimaryKey: id) {
                    firstnameDB.isFavorite.toggle()
                }
            }
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
    
    func count() -> Int {
        let realm = try! Realm()

        return realm.objects(FirstnameDB.self).count
    }
    
    func searchFirstnames(searchString: String) async throws -> [FirstnameDB] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let realm = try Realm()
                
                // Create a case-insensitive, "contains" predicate for the firstname
                let predicate = NSPredicate(format: "firstname CONTAINS[c] %@", searchString)
                
                // Query the Realm database
                let results = realm.objects(FirstnameDB.self).filter(predicate)
                
                // Convert Results to Array
                let firstnames = Array(results)
                
                continuation.resume(returning: firstnames)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getFavoritedFirstnames() async throws -> [FirstnameDB] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let realm = try Realm()
                let favorites = realm.objects(FirstnameDB.self).filter("isFavorite == true")
                let favoritesArray = Array(favorites)
                continuation.resume(returning: favoritesArray)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func toggleFavorited(firstname: FirstnameDB) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let realm = try Realm()
                try realm.write {
                    firstname.isFavorite.toggle()
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func convertToFirstnameDB(_ firstname: FirstnameDataModel) -> FirstnameDB {
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
}
