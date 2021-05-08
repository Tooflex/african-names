//
//  MenuView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.verticalSizeClass) var vSizeClass
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 360 * CGFloat(sizeMultiplier()), height: 80, alignment: .center)
                .foregroundColor(.offWhite)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            HStack(alignment: .center, spacing: 60.0 * CGFloat(sizeMultiplier())) {
                Image("search")
                Image("my-list")
                Image("share")
                Image("params")
            }
        }
    }
    
    func sizeMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 2
        } else {
            return 1
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
        
        MenuView()
            .previewDevice(PreviewDevice(rawValue: "iPad 12"))
            .previewDisplayName("iPad 12")
    }
}
