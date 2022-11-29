//
//  FirstnameResponse.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/11/2022.
//

import Foundation

struct FirstnameResponse: Codable {
	let content: [FirstnameDataModel]?
	let pageable: Pageable?
	let totalPages: Int?
	let totalElements: Int?
	let last: Bool?
	let numberOfElements: Int?
	let sort: Sort?
	let first: Bool?
	let size: Int?
	let number: Int?
	let empty: Bool?

	enum CodingKeys: String, CodingKey {

		case content
		case pageable
		case totalPages
		case totalElements
		case last
		case numberOfElements
		case sort
		case first
		case size
		case number
		case empty
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		content = try values.decodeIfPresent([FirstnameDataModel].self, forKey: .content)
		pageable = try values.decodeIfPresent(Pageable.self, forKey: .pageable)
		totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
		totalElements = try values.decodeIfPresent(Int.self, forKey: .totalElements)
		last = try values.decodeIfPresent(Bool.self, forKey: .last)
		numberOfElements = try values.decodeIfPresent(Int.self, forKey: .numberOfElements)
		sort = try values.decodeIfPresent(Sort.self, forKey: .sort)
		first = try values.decodeIfPresent(Bool.self, forKey: .first)
		size = try values.decodeIfPresent(Int.self, forKey: .size)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		empty = try values.decodeIfPresent(Bool.self, forKey: .empty)
	}

}
