//
//  Pageable.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 28/11/2022.
//

import Foundation

struct Pageable: Codable {
	let sort: Sort?
	let pageNumber: Int?
	let pageSize: Int?
	let offset: Int?
	let unpaged: Bool?
	let paged: Bool?

	enum CodingKeys: String, CodingKey {

		case sort
		case pageNumber
		case pageSize
		case offset
		case unpaged
		case paged
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sort = try values.decodeIfPresent(Sort.self, forKey: .sort)
		pageNumber = try values.decodeIfPresent(Int.self, forKey: .pageNumber)
		pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
		offset = try values.decodeIfPresent(Int.self, forKey: .offset)
		unpaged = try values.decodeIfPresent(Bool.self, forKey: .unpaged)
		paged = try values.decodeIfPresent(Bool.self, forKey: .paged)
	}

}
