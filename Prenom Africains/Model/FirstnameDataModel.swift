//
//  PrenonAF.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/04/2021.
//

import Foundation
import RealmSwift

struct FirstnameTranslationModel: Codable, Hashable {
    var meaningTranslation: String?
    var originsTranslation: String?
    var languageCode: String?

    init(meaningTranslation: String? = nil, originsTranslation: String? = nil, languageCode: String? = nil) {
        self.meaningTranslation = meaningTranslation
        self.originsTranslation = originsTranslation
        self.languageCode = languageCode
    }
    
    enum CodingKeys: String, CodingKey {
        case meaningTranslation = "meaning_translation"
        case originsTranslation = "origins_translation"
        case languageCode = "language_code"
    }
}

struct FirstnameDataModel: Identifiable, Codable, Hashable {
    var id: Int?
    var firstname: String?
    var gender: Gender
    var isFavorite: Bool
    var meaning: String?
    var meaningMore: String?
    var origins: String?
    var soundURL: String?
    var regions: String?
    var size: Size?
    var translations: [FirstnameTranslationModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstname
        case gender
        case meaning
        case meaningMore = "meaning_more"
        case origins
        case soundURL = "sound_url"
        case regions
        case size
        case translations = "firstname_translation" // Changed from translation to translations to match the property name
    }

    init() {
        self.id = 0
        self.firstname = "No Firstname"
        self.meaning = "No meaning"
        self.meaningMore = ""
        self.origins = "No origins"
        self.soundURL = ""
        self.regions = ""
        self.gender = Gender.undefined
        self.isFavorite = false
        self.size = Size.undefined
        self.translations = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
        firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        meaning = try container.decodeIfPresent(String.self, forKey: .meaning)
        meaningMore = try container.decodeIfPresent(String.self, forKey: .meaningMore)
        origins = try container.decodeIfPresent(String.self, forKey: .origins)
        soundURL = try container.decodeIfPresent(String.self, forKey: .soundURL)
        regions = try container.decodeIfPresent(String.self, forKey: .regions)

        let genderString = try container.decodeIfPresent(String.self, forKey: .gender)
        gender = Gender(rawValue: genderString?.lowercased() ?? "") ?? Gender.undefined

        isFavorite = false

        let sizeString = try container.decodeIfPresent(String.self, forKey: .size)
        size = Size(rawValue: sizeString?.lowercased() ?? "") ?? Size.undefined
        
        translations = try container.decodeIfPresent([FirstnameTranslationModel].self, forKey: .translations)
    }
}

// MARK: Convenience init
extension FirstnameDataModel {
    var translation: FirstnameTranslationModel? {
        return translations?.first
    }
    
    init(firstnameDB: FirstnameDB) {
        id = firstnameDB.id
        firstname = firstnameDB.firstname
        gender = Gender(rawValue: firstnameDB.gender) ?? Gender.undefined
        isFavorite = firstnameDB.isFavorite
        meaning = firstnameDB.meaning
        meaningMore = firstnameDB.meaningMore
        origins = firstnameDB.origins
        soundURL = firstnameDB.soundURL
        regions = firstnameDB.regions
        size = Size(rawValue: firstnameDB.firstnameSize) ?? Size.undefined
    }
}

extension FirstnameDataModel: Equatable {
    static func == (lhs: FirstnameDataModel, rhs: FirstnameDataModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.firstname == rhs.firstname &&
        lhs.meaning == rhs.meaning &&
		lhs.meaningMore == rhs.meaningMore &&
        lhs.origins == rhs.origins &&
        lhs.soundURL == rhs.soundURL &&
        lhs.isFavorite == rhs.isFavorite &&
        lhs.regions == rhs.regions &&
        lhs.size == rhs.size
    }
}
