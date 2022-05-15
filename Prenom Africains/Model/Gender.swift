//
//  Gender.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation

enum Gender: String, CaseIterable, Codable {
    case male
    case female
    case mixed
    case undefined

    var title: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .mixed:
            return "mixed"
        case .undefined:
            return "undefined"
        }
    }
}
