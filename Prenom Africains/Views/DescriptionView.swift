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
    @State private var isLiked = false
    
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                HStack (alignment:.center) {
                    Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.offWhite.opacity(0.71))
                        .frame(width: UIScreen.main.bounds.width - 50, height: 165 * CGFloat(sizeMultiplier()), alignment: .center)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    Text(prenom.meaning ?? "")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 100 * CGFloat(sizeMultiplier()), alignment: .center)
                }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(idealWidth: geometry.size.width * 0.8, maxHeight: geometry.size.height, alignment: .center)
            }
            
            HStack {
                switch prenom.gender {
                case Gender.male:
                    HStack {
                        Image("md-male")
                            .resizable()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                        //.padding()
                    }
                    
                case Gender.female:
                    HStack {
                        Image("md-female")
                            .resizable()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                        //.padding()
                    }
                case Gender.mixed:
                    HStack {
                        Image("md-male")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                            //.padding()
                        Image("md-female")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                           // .padding()
                    }
                case .undefined:
                    EmptyView()
                        .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()), alignment: .center)
                //.padding()
                }
                
                Spacer()
                Text("Origins: \(prenom.origins ?? "")")
                    .font(.title2)
                    .lineLimit(1)
                    .padding(.horizontal)
            }.frame(alignment: .center)
            
            if !isLiked {
                Button(action: {
                    self.isLiked.toggle()
                }) {
                    LottieView(name: "heart_like", fromMarker: "touchDownStart", toMarker: "touchUpEnd")
                        .padding(.all, -40)
                        .frame(width: 40 * CGFloat(sizeMultiplier()), height: 40 * CGFloat(sizeMultiplier())
                               , alignment: .center)
                }
                
            } else {
                Button(action: {
                    self.isLiked.toggle()
                    
                }) {
                    LottieView(name: "heart_like", fromMarker: "touchDownStart1", toMarker: "touchUpEnd1")
                        .padding(.all, -40)
                        .frame(width: 40 * CGFloat(sizeMultiplier()), height: 40 * CGFloat(sizeMultiplier())
                               , alignment: .center)
                }
            }
            Spacer()
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
        ForEach(ColorScheme.allCases, id: \.self) {
            Group {
                DescriptionView(prenom: PrenomAF())
                    .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                    .previewDisplayName("iPad Pro 12")
                    .landscape()
                
                DescriptionView(prenom: PrenomAF())
                    .previewDevice("iPhone 12 Pro Max")
                    .previewDisplayName("iPhone 12 Pro Max")
            }.preferredColorScheme($0)
        }
        
    }
}
