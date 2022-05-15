//
//  PopoverView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 26/11/2021.
//

import SwiftUI

struct PopoverView: View {

    @State var text: LocalizedStringKey
    @State var textMore: String

    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .fontWeight(.heavy)
            }
            .font(.largeTitle)
            .padding()
            Text(textMore)
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView(text: "test1", textMore: "test")
    }
}
