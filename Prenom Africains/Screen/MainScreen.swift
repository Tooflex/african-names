//
//  MainScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import CoreData

struct MainScreen: View {
    
    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @State private var currentPrenom: PrenomAF = PrenomAF()
    
    @State private var currentColor = Color.gray
    
    @State private var currentIndex = 0
    
    @ObservedObject var firstNameViewModel : FirstNameViewModel
            
    var body: some View {
        ZStack {
            Color.offWhite
            VStack {
               Spacer()
                HStack {
                    Triangle()
                        .fill(setColor())
                        .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
                        .rotationEffect(.degrees(-90))
                        .onTapGesture {
                            previousFirstname()
                        }
                    // iPad Full or 1/2
                    if vSizeClass == .regular && hSizeClass == .regular {
                        VStack {
                            Spacer()
                            CircleFirstName(prenom: currentPrenom, color: setColor())
                                .padding(.bottom)
                                .frame(width: 600, height: 600)
                            Spacer()
                        }
                        
                    } else {
                        CircleFirstName(prenom: currentPrenom, color: setColor())
                            .padding(.bottom)
                    }
          
                    
                    Triangle()
                        .fill(setColor())
                        .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
                        .rotationEffect(.degrees(90))
                        .onTapGesture {
                            nextFirstname()
                        }
                }
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width as CGFloat
                                let verticalAmount = value.translation.height as CGFloat
                                
                                if abs(horizontalAmount) > abs(verticalAmount) {
                                    print(horizontalAmount < 0 ? nextFirstname() : previousFirstname())
                                }
                            })
                DescriptionView(prenom: currentPrenom)
                    .padding(.horizontal)
                //Spacer()
                MenuView()
                Spacer()
                    .frame(height:30)
                    
            }
        }.onReceive(firstNameViewModel.$firstnames) { firstnames in
            if(!firstnames.isEmpty) {
                currentPrenom = firstnames[currentIndex]
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func sizeMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 3
        } else {
            return 1
        }
    }
    
    func setColor() -> Color {
        switch currentPrenom.gender {
            case Gender.male:
                return Color.blue
            case Gender.female:
                return Color.pink
            case Gender.mixed:
                return Color.purple
        case .undefined:
            return Color.black
        }
    }
    
    func nextFirstname() {
        if(self.currentIndex < firstNameViewModel.firstnames.count-1) {
            self.currentIndex = currentIndex + 1
            currentPrenom = firstNameViewModel.firstnames[currentIndex]
        }
    }
    
    func previousFirstname() {
        if(self.currentIndex > 0) {
            self.currentIndex = currentIndex - 1
            currentPrenom = firstNameViewModel.firstnames[currentIndex]
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        let firstNameViewModel = FirstNameViewModel()
        
        MainScreen(firstNameViewModel: firstNameViewModel)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad 12")
        
        MainScreen(firstNameViewModel: firstNameViewModel)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
    }
}
