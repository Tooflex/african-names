//
//  FilterChip.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 12/11/2021.
//

import SwiftUI

struct FilterChip: View {

    var text: String = "Filters"
    var color: Color = .black
    let action: () -> Void

    var body: some View {
        HStack {

            Button {
                self.action()
            } label: {
                Text("\(text) x")
                    .font(.system(size: 12))
                    .foregroundColor(color)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color, lineWidth: 3)
                            .frame(width: 100, height: 30)
                    )
            }

        }

    }

}

struct FilterChip_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            Group {
                FilterChip(action: {})
                    .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                    .previewDisplayName("iPad Pro 12")
                    .landscape()

                FilterChip(action: {})
                    .previewDevice("iPhone 12 Pro Max")
                    .previewDisplayName("iPhone 12 Pro Max")
            }.preferredColorScheme($0)
        }

    }
}
