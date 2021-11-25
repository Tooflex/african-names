//
//  Configuration.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 25/11/2021.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        switch object {
            case let value as T:
                return value
            case let string as String:
                guard let value = T(string) else { fallthrough }
                return value
            default:
                throw Error.invalidValue
        }
    }
}

enum API {
    static var baseURL: URL {
        // swiftlint:disable force_try
        return try! URL(string: "https://" + Configuration.value(for: "API_ENDPOINT"))!
    }
}
