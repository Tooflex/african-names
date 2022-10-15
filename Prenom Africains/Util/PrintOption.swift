//
//  PrintOption.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 01/10/2022.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
// #if DEBUG
	items.forEach {
		Swift.print($0, separator: separator, terminator: terminator)
	}
// #endif
}
