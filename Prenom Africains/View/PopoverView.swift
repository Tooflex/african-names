//
//  PopoverView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 26/11/2021.
//

import SwiftUI

struct PopoverView: View {

	@State var title: LocalizedStringKey = "Meaning"
	@State var titleMore: LocalizedStringKey = "More"
    @State var text: String
    @State var textMore: String

    var body: some View {
        VStack {
            HStack {
				Text(title)
                    .fontWeight(.heavy)
            }
            .font(.largeTitle)
            .padding()
			Text(text)
			Divider()
				.padding(.bottom)

			Collapsible(
				label: { Text(titleMore) },
				content: {
					HStack {
						Text(textMore)
						Spacer()
					}
					.frame(maxWidth: .infinity)
					.padding()
				}
			)
			.frame(maxWidth: .infinity)

			Spacer()
        }
		.padding()
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(text: "test1", textMore: "test")
    }
}
