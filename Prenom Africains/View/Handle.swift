//
//  Handle.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 10/05/2021.
//

import SwiftUI

struct Handle: View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}
