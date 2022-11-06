//
//  AuthToken.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 01/10/2022.
//

import Foundation

class AuthToken: AccessTokenStorage, Decodable, Encodable {
	var account = "africannames.app"
	var service = "jwt_token"

	var accessToken: JWT {
		get {
			return KeychainManager.standard.read(service: service,
												 account: account,
												 type: String.self) ?? ""
		}

		set {
			KeychainManager.standard.save(newValue, service: service, account: account)
		}
	}
}
