//
//  FirstnameDB.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 14/06/2021.
//

import Foundation
import RealmSwift

class FirstnameDB: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstname = ""
    @objc dynamic var gender = ""
    @objc dynamic var isFavorite = false
    @objc dynamic var meaning = ""
    @objc dynamic var origins = ""
    @objc dynamic var soundURL = ""

    override static func primaryKey() -> String? {
        "id"
    }

}
