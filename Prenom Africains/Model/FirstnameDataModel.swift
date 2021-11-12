//
//  PrenonAF.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/04/2021.
//

import Foundation
import RealmSwift

struct FirstnameDataModel: Identifiable, Codable, Hashable {

    var id: Int?
    var firstname: String?
    var gender: Gender
    var isFavorite: Bool
    var meaning: String?
    var origins: String?
    var soundURL: String?
    var regions: String?
    var size: Size?

    init() {
        self.id = 0
        self.firstname = "No Firstname"
        self.meaning = "No meaning"
        self.origins = "No origins"
        self.soundURL = ""
        self.regions = ""
        self.gender = Gender.undefined
        self.isFavorite = false
        self.size = Size.undefined
    }

    enum CodingKeys: String, CodingKey {
        case id, firstname, gender, meaning, origins, soundURL, regions, size
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)

        firstname = try container.decodeIfPresent(String.self, forKey: .firstname)

        meaning = try container.decodeIfPresent(String.self, forKey: .meaning)

        origins = try container.decodeIfPresent(String.self, forKey: .origins)

        soundURL = try container.decodeIfPresent(String.self, forKey: .soundURL)

        regions = try container.decodeIfPresent(String.self, forKey: .regions)

        let genderString = try container.decodeIfPresent(String.self, forKey: .gender)

        gender = Gender(rawValue: genderString?.lowercased() ?? "") ?? Gender.undefined

        isFavorite = false

        let sizeString = try container.decodeIfPresent(String.self, forKey: .size)

        size = Size(rawValue: sizeString?.lowercased() ?? "") ?? Size.undefined
    }
}

// MARK: Convenience init
extension FirstnameDataModel {
    init(firstnameDB: FirstnameDB) {
        id = firstnameDB.id
        firstname = firstnameDB.firstname
        gender = Gender(rawValue: firstnameDB.gender) ?? Gender.undefined
        isFavorite = firstnameDB.isFavorite
        meaning = firstnameDB.meaning
        origins = firstnameDB.origins
        soundURL = firstnameDB.soundURL
        regions = firstnameDB.regions
        size = Size(rawValue: firstnameDB.firstnameSize) ?? Size.undefined
    }
}

extension FirstnameDataModel: Equatable {
    static func == (lhs: FirstnameDataModel, rhs: FirstnameDataModel) -> Bool {
        return
        lhs.id == rhs.id &&
        lhs.firstname == rhs.firstname &&
        lhs.meaning == rhs.meaning &&
        lhs.origins == rhs.origins &&
        lhs.soundURL == rhs.soundURL &&
        lhs.isFavorite == rhs.isFavorite &&
        lhs.regions == rhs.regions &&
        lhs.size == rhs.size
    }
}
