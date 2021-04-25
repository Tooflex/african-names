//
//  PrenonAF.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/04/2021.
//

import Foundation

struct PrenomAF: Identifiable, Codable  {
    
    var firstname: String?
    var gender: Gender
    var id: Float?
    var isFavorite: Bool?
    var meaning: String?
    var origins: String?
    var soundURL: String?
    
    init() {
        self.firstname = ""
        self.meaning = ""
        self.origins = ""
        self.soundURL = ""
        self.gender = Gender.undefined
        self.isFavorite = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstname, gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        
        let genderString = try container.decode(String.self, forKey: .gender)
        gender = Gender(rawValue: genderString.lowercased()) ?? Gender.undefined
    } 
}
