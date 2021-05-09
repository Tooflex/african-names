//
//  SearchScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI

struct SearchScreen: View {
    @State private var vibrateOnRing = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Search")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            // Filters Options
            Group {
            SearchBarView(text: .constant(""))
                .padding(.horizontal)
            HStack() {
                Toggle("Only show favorites", isOn: $vibrateOnRing).padding()
            }
            ChipsOptionView(title: "Area")
            ChipsOptionView(title: "Origins")
            Text("Gender")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            HStack {
                Image("md-female")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                Image("md-male").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            ChipsOptionView(title: "Size")
            }
            // Filter Submit Button
            Button(action: {
                print("Filter tapped!")
            }) {
                HStack {
                    Text("Filter")
                        .fontWeight(.medium)
                        .font(.title2)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }.padding()
            Spacer()
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
