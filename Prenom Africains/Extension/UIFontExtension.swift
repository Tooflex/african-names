//
//  UIFontExtension.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 20/11/2022.
//

import SwiftUI

extension UIFont {
	class func preferredFont(from font: Font) -> UIFont {
		let style: UIFont.TextStyle
		switch font {
			case .largeTitle:  style = .largeTitle
			case .title:       style = .title1
			case .title2:      style = .title2
			case .title3:      style = .title3
			case .headline:    style = .headline
			case .subheadline: style = .subheadline
			case .callout:     style = .callout
			case .caption:     style = .caption1
			case .caption2:    style = .caption2
			case .footnote:    style = .footnote
			case .body:		   style = .body
			default:           style = .body
		}
		return  UIFont.preferredFont(forTextStyle: style)
	}
}
