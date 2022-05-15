//
//  SearchBarButton.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 12/05/2021.
//

import SwiftUI
import L10n_swift

struct SearchBarButton: View {
    @Binding var showingSheet: Bool

    var body: some View {
        Button(action: {
            showingSheet = true
        }, label: {
            HStack(alignment: .center, spacing: 30) {
                Image("feather-search")
                    .foregroundColor(Color("black"))
                Text("Search a firstname".l10n())
                    .foregroundColor(Color("black"))
            }
        })
        .frame(minWidth: 100, maxWidth: .infinity)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("gray"), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}

struct SearchBarButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarButton(showingSheet: .constant(false))
    }
}
