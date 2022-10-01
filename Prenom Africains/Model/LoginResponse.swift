//
//  LoginResponse.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 01/10/2022.
//

import Foundation

struct LoginResponse: Decodable {
	var id: Int?
	var username: String?
	var email: String?
	var jwt: String?
}
