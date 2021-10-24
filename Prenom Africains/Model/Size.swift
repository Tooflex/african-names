//
//  Size.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 24/10/2021.
//

import Foundation

enum Size: String, CaseIterable, Codable {
    case short
    case medium
    case long
    case undefined

    var title: String {
        switch self {
        case .short:
            return "short"
        case .medium:
            return "medium"
        case .long:
            return "long"
        case .undefined:
            return "undefined"
        }
    }
}
