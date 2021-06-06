//
//  ChipsView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import SwiftUI

struct ChipsView: View {
    @ObservedObject var chip: ChipsDataModel
    var body: some View {
        HStack {
            if let systemImage = chip.systemImage {
                Image.init(systemName: systemImage).font(.title3)
            }
            Text(chip.titleKey).font(.title3).lineLimit(1)
        }.padding(.all, 10)
        .foregroundColor(chip.isSelected ? .white : .blue)
        .background(chip.isSelected ? Color.blue : Color.white)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.blue, lineWidth: 1.5)
        )
    }
}

 struct ChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipsView(chip: ChipsDataModel(isSelected: false, titleKey: "test"))
    }
 }
