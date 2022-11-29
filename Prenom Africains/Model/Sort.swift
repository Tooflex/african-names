//
//  Sort.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 28/11/2022.
//

import Foundation

struct Sort: Codable {
	let sorted: Bool?
	let unsorted: Bool?
	let empty: Bool?

	enum CodingKeys: String, CodingKey {

		case sorted
		case unsorted
		case empty
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sorted = try values.decodeIfPresent(Bool.self, forKey: .sorted)
		unsorted = try values.decodeIfPresent(Bool.self, forKey: .unsorted)
		empty = try values.decodeIfPresent(Bool.self, forKey: .empty)
	}

}
