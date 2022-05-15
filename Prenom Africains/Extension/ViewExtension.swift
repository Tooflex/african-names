//
//  ViewExtension.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI

extension View {
    func sizeMultiplier(
        _ vSizeClass: UserInterfaceSizeClass?,
        _ hSizeClass: UserInterfaceSizeClass?,
        regularConstant: CGFloat = 2,
        otherConstant: CGFloat = 1 ) -> CGFloat {
        if vSizeClass == .regular && hSizeClass == .regular { // Compact width, regular height
            return regularConstant
        } else {
            return otherConstant
        }
    }

    func landscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}
