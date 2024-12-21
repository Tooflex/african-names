//
//  FirstnameTranslationDB.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 12/20/24.
//


import Foundation
import RealmSwift

class FirstnameTranslationDB: Object {
    @objc dynamic var meaningTranslation = ""
    @objc dynamic var originsTranslation = ""
    @objc dynamic var languageCode = ""
    
    // Required for Realm to connect translations to firstnames
    let firstname = LinkingObjects(fromType: FirstnameDB.self, property: "translations")
}