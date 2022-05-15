//
//  AdaptiveView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 29/04/2021.
//

import SwiftUI

struct AdaptiveView<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if horizontalSizeClass == .regular {
            HStack {
                content
            }
        } else {
            VStack {
                content
            }
        }
    }
}
