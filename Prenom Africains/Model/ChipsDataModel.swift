//
//  ChipsDataModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 30/05/2021.
//

import SwiftUI

class ChipsDataModel: Identifiable, ObservableObject {
    let id = UUID()
    @Published var isSelected: Bool = false
    var systemImage: String?
    var titleKey: String = ""

    init(isSelected: Bool, titleKey: String) {
        self.titleKey = titleKey
        self.isSelected = isSelected
    }
}
