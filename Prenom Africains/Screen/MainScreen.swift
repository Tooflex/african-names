//
//  MainScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI

struct MainScreen: View {

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @State private var currentColor = Color.gray

    @State private var currentIndex = 0

    @Binding var searchString: NSCompoundPredicate

    @EnvironmentObject var firstNameViewModel: FirstNameViewModel

    @State private var listOfFirstnamesToDisplay: [FirstnameDB] = []

    fileprivate func leftButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(-90))
            .onTapGesture {
                previousFirstname()
            }
    }

    fileprivate func rightButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(90))
            .onTapGesture {
                nextFirstname()
            }
    }

    var body: some View {
            VStack {
               Spacer()
                HStack {
                    if isPreviousFirstname() {
                        leftButton()
                    } else {
                        Spacer().frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
                    }
                    // iPad Full or 1/2
                    if vSizeClass == .regular && hSizeClass == .regular {
                        VStack {
                            Spacer()
                            CircleFirstName(prenom: firstNameViewModel.currentFirstname, color: setColor())
                                .padding(.bottom)
                                .frame(width: 600, height: 600)
                            Spacer()
                        }

                    } else {
                        CircleFirstName(prenom: firstNameViewModel.currentFirstname, color: setColor())
                            .padding(.bottom)
                    }

                    if isNextFirstname() {
                        rightButton()
                    } else {
                        Spacer().frame(width: 30 * CGFloat(sizeMultiplier()), height: 30 * CGFloat(sizeMultiplier()))
                    }
                }
                DescriptionView()
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            let horizontalAmount = value.translation.width as CGFloat
                            let verticalAmount = value.translation.height as CGFloat

                            if abs(horizontalAmount) > abs(verticalAmount) {
                                print(horizontalAmount < 0 ? nextFirstname() : previousFirstname())
                            }
                        })
            .padding(.vertical)
            .onAppear(perform: {
                firstNameViewModel.onAppear()
            })
        .onReceive(firstNameViewModel.$firstnamesResults) { firstnames in
            if let firstnames = firstnames {
                if !firstnames.isEmpty {
                    firstNameViewModel.currentFirstname = firstnames[currentIndex]
                }
            }
        }
    }

    func sizeMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 4
        } else {
            return 1
        }
    }

    func paddingMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 70
        } else {
            return 1
        }
    }

    func setColor() -> Color {
        switch firstNameViewModel.currentFirstname.gender {
        case Gender.male.rawValue:
            return Color.blue
        case Gender.female.rawValue:
            return Color.pink
        case Gender.mixed.rawValue:
            return Color.purple
        case Gender.undefined.rawValue:
            return Color.black
        default:
            return Color.black
        }
    }

    fileprivate func isNextFirstname() -> Bool {
        if let firstnames = firstNameViewModel.firstnamesResults {
            return self.currentIndex < firstnames.count-1
        } else {
            return false
        }

    }

    func nextFirstname() {
        if isNextFirstname() {
            if let firstnames = firstNameViewModel.firstnamesResults {
            self.currentIndex = currentIndex + 1
            firstNameViewModel.currentFirstname = firstnames[currentIndex]
            }
        }
    }

    fileprivate func isPreviousFirstname() -> Bool {
        return self.currentIndex > 0
    }

    func previousFirstname() {
        if isPreviousFirstname() {
            if let firstnames = firstNameViewModel.firstnamesResults {
            self.currentIndex = currentIndex - 1
            firstNameViewModel.currentFirstname = firstnames[currentIndex]
            }
        }
    }
}

// struct MainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ForEach(ColorScheme.allCases, id: \.self) {
//        Group {
//            MainScreen()
//                .previewDevice("iPhone 12")
//                .previewDisplayName("iPhone 12")
//
//            MainScreen()
//                .previewDevice("iPhone 8 Plus")
//                .previewDisplayName("iPhone 8 Plus")
//
//            MainScreen()
//                .previewDevice("iPhone 8")
//                .previewDisplayName("iPhone 8")
//        }.preferredColorScheme($0)
//        }
//
//    }
// }
