//
//  SearchBarView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 08/05/2021.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack (alignment: .center, spacing: 30)  {
            Image("feather-search").foregroundColor(.black)
            TextField("Search a firstname", text: $text)
               .textFieldStyle(DefaultTextFieldStyle())
                .id(true) //Force TextField to accept editable
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
