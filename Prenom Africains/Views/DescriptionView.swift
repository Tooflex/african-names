//
//  DescriptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI

struct DescriptionView: View {
    @Environment(\.verticalSizeClass) var vSizeClass
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var prenom: PrenomAF
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.offWhite.opacity(0.71))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 165 * CGFloat(sizeMultiplier()))
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                Text(prenom.meaning ?? "")
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 100 * CGFloat(sizeMultiplier()), alignment: .center)
                    .padding(.horizontal)
            }
            VStack {
                HStack {
                    switch prenom.gender {
                    case Gender.male:
                        HStack {
                        Image("md-male")
                            .resizable()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                            .padding()
                        }
                            
                    case Gender.female:
                        HStack {
                        Image("md-female")
                            .resizable()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                            .padding()
                        }
                    case Gender.mixed:
                        HStack {
                            Image("md-male")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                            Image("md-female")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                        }
                    case .undefined:
                        EmptyView()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                            .padding()
                    }
                    
                    Spacer()
                    Text("Origine: \(prenom.origins ?? "")")
                        .font(.title3)
                        .lineLimit(1)
                        .padding()
                }
                Image("favorite-border")
                    .resizable()
                    .frame(width: 40 * CGFloat(sizeMultiplier()), height: 40 * CGFloat(sizeMultiplier())
                           , alignment: .center)
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

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DescriptionView(prenom: PrenomAF())
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            .previewDisplayName("iPad Pro 12")
        
        DescriptionView(prenom: PrenomAF())
            .previewDevice("iPhone 12 Pro Max")
            .previewDisplayName("iPhone 12 Pro Max")
    }
    }
}
