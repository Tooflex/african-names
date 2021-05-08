//
//  LandscapeModifier.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 29/04/2021.
//

import SwiftUI

struct LandscapeModifier: ViewModifier {
    let height = UIScreen.main.bounds.width
    let width = UIScreen.main.bounds.height
    
    var isPad: Bool { // 1
        return height >= 768
    }
    
    var isRegularWidth: Bool { // 2
        return height >= 414
    }
    
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: width, height: height))
            .environment(\.horizontalSizeClass, isRegularWidth ? .regular: .compact) // 5
            .environment(\.verticalSizeClass, isPad ? .regular: .compact) // 6
    }
}

extension View {
    func landscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}
